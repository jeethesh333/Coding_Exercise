#import necessary modules
import gzip
import json
import pandas as pd
import datetime


# extracting the data
def load_gzipped_json(file_path):
    """
    Load a gzipped JSON file and return a DataFrame.
    The function first attempts to load the file using pd.read_json assuming JSON Lines format.
    If that fails, it falls back to manually parsing each line with json.loads.
    It also skips any header lines that start with the file's base name.
    """
    try:
        # Attempt to read the file assuming JSON Lines format
        df = pd.read_json(file_path, compression='gzip', lines=True)
        return df
    except ValueError as e:
        print(f"pd.read_json failed for {file_path}: {e}")
        # Fallback: manually parse each line
        data = []
        # Get the base name (e.g., 'users.json' becomes 'users.json' without '.gz')
        base_name = file_path.split("/")[-1].replace(".gz", "")
        with gzip.open(file_path, 'rt', encoding='utf-8') as f:
            for line in f:
                # Skip empty lines and lines that start with the base name (likely header lines)
                if line.strip() and not line.startswith(base_name):
                    try:
                        data.append(json.loads(line))
                    except json.JSONDecodeError:
                        continue
        return pd.DataFrame(data)
        

#transforming the extracted data
def convert_oid(value):
    """
    Converts a MongoDB ObjectId represented as a dict (e.g., {'$oid': '...'})
    into its string representation.
    """
    if isinstance(value, dict) and '$oid' in value:
        return value['$oid']
    return value

def convert_date(value):
    """
    Converts a MongoDB date representation (e.g., {'$date': 1609687531000})
    into a Python datetime object.
    """
    if isinstance(value, dict) and '$date' in value:
        return datetime.datetime.fromtimestamp(value['$date'] / 1000)
    return value

def convert_cpg(value):
    """
    Converts a MongoDB format cpg field (e.g.,
      {'$id': {'$oid': '601ac114be37ce2ead437550'}, '$ref': 'Cogs'})
    into a simplified dictionary with keys 'cpg_id' and 'cpg_ref'.
    """
    if isinstance(value, dict) and '$id' in value and '$ref' in value:
        # Extract the id string from the nested dictionary.
        if isinstance(value['$id'], dict) and '$oid' in value['$id']:
            cpg_id = value['$id']['$oid']
        else:
            cpg_id = value['$id']
        cpg_ref = value.get('$ref')
        return {'cpg_id': cpg_id, 'cpg_ref': cpg_ref}
    return value


def apply_conversions(df):
    """
    Apply conversions to a DataFrame by converting MongoDB ObjectIDs and dates.
    
    This function checks for known columns that may contain ObjectIDs ('_id', 'userId', 'brand_id)
    and applies the corresponding conversion functions.
    """
    # Convert ObjectID columns if they exist.
    oid_columns = ['_id', 'userId', 'brand_id', 'receiptId']
    for col in oid_columns:
        if col in df.columns:
            df[col] = df[col].apply(convert_oid)
    
    # Define a list of common date column names
    date_columns = ['createDate', 'createdDate', 'lastLogin', 'purchaseDate', 'dateScanned', 'finishedDate', 'modifyDate', 'pointsAwardedDate']
    for col in date_columns:
        if col in df.columns:
            df[col] = df[col].apply(convert_date)

    if 'cpg' in df.columns:
        df['cpg'] = df['cpg'].apply(convert_cpg)
    
    return df


# Define file paths for each dataset
file_paths = {
    'receipts': 'data/input_data/receipts.json.gz',
    'users': 'data/input_data/users.json.gz',
    'brands': 'data/input_data/brands.json.gz'
}

receipts_df = load_gzipped_json('data/input_data/receipts.json.gz')

brands_df = load_gzipped_json('data/input_data/brands.json.gz')

    # ✅ Step 2: Explode rewardsReceiptItemList (convert lists into separate rows)
exploded_df = receipts_df.explode('rewardsReceiptItemList')

    # ✅ Step 3: Normalize (flatten) the dictionary data into structured columns
rewardsReceiptItemList_df = pd.json_normalize(exploded_df['rewardsReceiptItemList'])

    # ✅ Step 4: Add `receiptId` from `receipts_df`
rewardsReceiptItemList_df['receiptId'] = exploded_df['_id'].values

# Drop the 'rewardsReceiptItemList' column from receipts_df.
receipts_df.drop(columns=['rewardsReceiptItemList'], inplace=True)

import uuid

rewardsReceiptItemList_df['item_id'] = [str(uuid.uuid4()) for _ in range(len(rewardsReceiptItemList_df))]  # Unique ID for each row

cols = ['item_id'] + [col for col in rewardsReceiptItemList_df.columns if col != 'item_id']
rewardsReceiptItemList_df = rewardsReceiptItemList_df[cols]

import pandas as pd
import spacy
import re
from sklearn.feature_extraction.text import TfidfVectorizer
from collections import Counter
from fuzzywuzzy import process
import nltk
from nltk.corpus import stopwords

# Download stopwords if not already available
nltk.download('stopwords')
stop_words = set(stopwords.words('english'))

# Load SpaCy NLP model
nlp = spacy.load("en_core_web_sm")



# Step 1: Use TF-IDF to detect frequent non-brand words
vectorizer = TfidfVectorizer(stop_words='english')
tfidf_matrix = vectorizer.fit_transform(rewardsReceiptItemList_df['description'].dropna())
feature_names = vectorizer.get_feature_names_out()

known_brands = brands_df['brandCode'].dropna().unique().tolist()
# Find top frequent words across descriptions
word_freq = Counter(" ".join(rewardsReceiptItemList_df['description'].dropna()).split())
common_words = [word.upper() for word, count in word_freq.items() if count > 1]

# Combine TF-IDF detected common words + English stopwords
excluded_words = set(common_words).union(stop_words)

# Step 2: Function to extract brand names dynamically
from fuzzywuzzy import process


def extract_brand(description):
    if pd.isna(description) or description.strip() == "ITEM NOT FOUND":
        return None  # Ignore 'ITEM NOT FOUND' and empty values

    doc = nlp(description.title())  # Capitalize first letters for better recognition
    possible_brands = []

    # Extract proper nouns (brands) using NLP Named Entity Recognition (NER)
    for token in doc:
        if token.ent_type_ in {"ORG", "PRODUCT"} or token.pos_ in {"PROPN", "NOUN"}:
            possible_brands.append(token.text)

    # Select the best candidate for the brand
    brand_name = " ".join(possible_brands[:2]) if len(possible_brands) > 1 else possible_brands[0] if possible_brands else description.split()[0]

    # Apply fuzzy matching to standardize brand names
    match_result = process.extractOne(brand_name.upper(), known_brands)

    if match_result:  # Check if extractOne() returned a valid match
        best_match, score = match_result
        if score > 85:  # If the match is strong, return the standardized brand name
            return best_match
    
    return brand_name  # Otherwise, return the extracted brand name





# Step 3: Fill missing brandcode values dynamically
rewardsReceiptItemList_df['brandCode'] = rewardsReceiptItemList_df['description'].apply(extract_brand)









users_df = load_gzipped_json('data/input_data/users.json.gz')
users_df = users_df.drop_duplicates(subset=['_id'])



if 'cpg' in brands_df.columns:
    # Convert the cpg field to a simplified dict using convert_cpg
    brands_df['cpg'] = brands_df['cpg'].apply(convert_cpg)
    # Flatten the series of dictionaries into a DataFrame
    cpg = brands_df['cpg']
    cpg_df = pd.DataFrame(cpg.tolist())  
    cpg_df = cpg_df.drop_duplicates().reset_index(drop=True)
    # Drop the 'cpg' column from brands_df.
    brands_df = brands_df.drop('cpg', axis=1)
else:
    cpg_df = pd.DataFrame()

# Remove duplicate rows in cpg
cpg_df = cpg_df.drop_duplicates(subset=['cpg_id'])


#create a dictionary of all dataframes
dataframes = {'receipts':receipts_df, 'users':users_df, 'brands':brands_df, 'rewardsReceiptItemList': rewardsReceiptItemList_df, 'cpg': cpg_df}


# Apply conversions to each DataFrame.
for name, df in dataframes.items():
    dataframes[name] = apply_conversions(df)

#loading the data
#convert the data to csv format
for name, df in dataframes.items():
    df.to_csv(f"data/output_data/{name}.csv",index=False)


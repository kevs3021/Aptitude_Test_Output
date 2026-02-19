import hashlib

def hash_text(text):
    # 1. Convert the text to bytes using UTF-8 encoding
    text_bytes = text.encode('utf-8')
    
    # 2. Apply the SHA-256 algorithm
    hash_object = hashlib.sha256(text_bytes)
    
    # 3. Get the hexadecimal representation of the hash
    hex_dig = hash_object.hexdigest()
    
    return hex_dig

# Test the function
input_string = input("Enter the text you want to hash: ")
hashed_string = hash_text(input_string)

print(f"\nOriginal: {input_string}")
print(f"Hashed (SHA-256): {hashed_string}")
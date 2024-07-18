import subprocess
import base64

def generate_rsa_key(key_filename):
    # Generate RSA private key
    subprocess.run([
        'openssl', 'genpkey', '-algorithm', 'RSA',
        '-out', key_filename, '-pkeyopt', 'rsa_keygen_bits:2048'
    ])

def generate_self_signed_cert(key_filename, cert_filename):
    # Generate a self-signed certificate
    subprocess.run([
        'openssl', 'req', '-x509', '-new', '-nodes',
        '-key', key_filename, '-sha256', '-days', '365',
        '-out', cert_filename, '-subj', '/CN=my-ca'
    ])

def encode_to_base64(filename, output_filename):
    # Read the file and encode its content to base64
    with open(filename, 'rb') as file:
        encoded_content = base64.b64encode(file.read()).decode('utf-8')
    # Write the base64 content to a new file
    with open(output_filename, 'w') as file:
        file.write(encoded_content)

def main():
    key_filename = 'ca-key.pem'
    cert_filename = 'ca-cert.pem'
    key_base64_filename = 'ca-key.pem.base64'
    cert_base64_filename = 'ca-cert.pem.base64'

    # Generate RSA private key and self-signed certificate
    generate_rsa_key(key_filename)
    generate_self_signed_cert(key_filename, cert_filename)

    # Encode the key and certificate to base64
    encode_to_base64(key_filename, key_base64_filename)
    encode_to_base64(cert_filename, cert_base64_filename)

    print(f'Generated key and certificate in base64:')
    print(f'{key_base64_filename}')
    print(f'{cert_base64_filename}')

if __name__ == '__main__':
    main()

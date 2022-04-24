# RSAKeys
This repository hosts the pod RSAKeys, a structure made in Swift that allows developers to have an easy experience when using RSA encryption. 
RSAKeys creates a Keys object, which has 2 variables: a public and private key. The public key is used to encrypt data, whereas the private key is used to decrypt data. All the functions to create keys and recreate keys based on public key strings is already in the Pod. 

# Installation
RSAKeys can be installed by adding ```pod 'RSAKeys'``` into the Podfile.

# Initialization
At the top of the Swift file, call ```import RSAKeys```.
To initialize the Keys object, simply use 1 of the 2 constructors:
```
var keys: Keys = Keys()
```
or
```
var keys: Keys = Keys(publicKey: SecKey, privateKey: SecKey)
```
The first is used when a public and private key need to be generated, and the second is used when they already exist, and the developer wants to simply reuse them in their Keys object, for which they just need to input their public and private key into the parameters, and the Keys object will register them.

# Encryption
To encrypt data using the Keys public key, just call
```
keys.encrypt(_ message: String)
```
which will return the encrypted String.

To encrypt data using another public key, just call
```
keys.encrypt(_ message: String, using publicKey: String)
```
which will return the encrypted String.

# Decryption
To decrypt data (encrypted using the Keys public key), which can only be done by using the Keys private key, just call
```
keys.decrypt(_ message: String)
```
which will return the decrypted String.

# Further Inquiries
If there are any questions, please email ```kharbandakrish23@gmail.com``` with them.

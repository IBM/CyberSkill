# Quick Start Guide - PQC File Encryptor

## 🚀 Getting Started

### Step 1: Start the Application
```bash
cd pqc-file-encryptor
run-java24.bat
```

**Wait for:**
```
INFO MainVerticle - PQC File Encryptor Started Successfully
INFO MainVerticle - HTTP Server: http://0.0.0.0:9999
```

### Step 2: Open Web Browser
Navigate to: **http://localhost:9999**

---

## 📝 First Time Use - Important!

### The Dashboard Will Be Empty Initially
When you first open the application, you'll see:
- **Dashboard Tab**: "No data available yet"
- **Comparison Tab**: Empty charts
- **Records Tab**: "No records found"

**This is normal!** You need to encrypt at least one file first.

---

## 🔐 How to Encrypt Your First File

### 1. Go to "Encrypt" Tab
Click the **"Encrypt"** tab at the top.

### 2. Upload a File
- Click **"Choose File"** button
- Select any file from your computer (text file, image, document, etc.)
- File will be uploaded automatically

### 3. Select Algorithm
Choose a Post-Quantum algorithm:
- **Kyber512** - Fast, smaller keys (security level 1)
- **Kyber768** - Balanced (security level 3) ⭐ Recommended
- **Kyber1024** - Maximum security, larger keys (security level 5)

### 4. Click "Encrypt File"
- Wait for encryption to complete
- You'll see a success message with:
  - Record ID
  - Original file name
  - Encrypted file name
  - File sizes
  - Key sizes

### 5. Check the Results
Now go to other tabs:

**Records Tab:**
- Shows your encrypted file
- Displays all metadata
- Shows key sizes
- Includes decrypt button

**Dashboard Tab:**
- Total encryptions: 1
- Algorithms used: 1
- Key size charts
- Statistics

**Comparison Tab:**
- Bar chart comparing PQC vs RSA-2048
- Shows size overhead
- Visual demonstration of quantum-safe trade-offs

---

## 📊 Understanding the Data

### What You'll See After Encryption

#### Records Tab
```
File: test.txt
ID: 1738596281697
Algorithm: KYBER_1024
Original Size: 1.5 KB
Encrypted Size: 1.6 KB
Public Key: 1,568 bytes
Private Key: 3,168 bytes
Encapsulated Key: 1,568 bytes
Created: 2/3/2026, 4:24:41 PM
```

#### Dashboard Tab
```
Encryption Summary:
- Total Encryptions: 1
- Algorithms Used: 1
- Average Key Sizes displayed in charts
```

#### Comparison Tab
```
Horizontal bar chart showing:
- KYBER_1024: 6,304 bytes total
- RSA-2048: 2,254 bytes total
- Overhead: +180% for quantum resistance!
```

---

## 🎯 Key Features to Demonstrate

### 1. Real Post-Quantum Cryptography
- Uses Java 24's native ML-KEM (Kyber) implementation
- NIST-standardized algorithm
- Not a simulation - actual quantum-safe encryption!

### 2. Hybrid Encryption
- **AES-256-GCM** encrypts your file data
- **ML-KEM (Kyber)** protects the AES key
- Best of both worlds: speed + quantum resistance

### 3. Size Trade-offs
- **Kyber512**: Smaller keys, faster
- **Kyber768**: Balanced (recommended)
- **Kyber1024**: Largest keys, maximum security

Compare the sizes:
```
Kyber1024 vs RSA-2048:
- Public Key: +433% larger
- Private Key: +86% larger
- Ciphertext: +513% larger
- Total: +180% overhead
```

**This is the price of quantum resistance!**

### 4. Persistent Storage
- All data saved to `data/` directory
- JSON format (human-readable)
- Survives application restarts
- Easy to backup

---

## 🔄 Workflow Example

### Complete Encryption Workflow
1. **Start Application** → `run-java24.bat`
2. **Open Browser** → http://localhost:9999
3. **Encrypt Tab** → Upload file
4. **Select Kyber1024** → Click Encrypt
5. **View Success** → See encryption details
6. **Records Tab** → See encrypted file listed
7. **Dashboard Tab** → See statistics
8. **Comparison Tab** → See size comparison chart

### Encrypt Multiple Files
- Repeat steps 3-4 with different files
- Dashboard updates automatically
- Statistics accumulate
- Compare different algorithms

---

## 📁 Where Files Are Stored

### Directory Structure
```
pqc-file-encryptor/
├── data/
│   ├── encryption_records.json    ← All your encryption records
│   └── key_statistics.json        ← Algorithm statistics
├── encrypted/
│   └── yourfile.txt.enc           ← Encrypted files
└── uploads/
    └── yourfile.txt               ← Original files
```

### View Your Data
```bash
# See all encryption records
type data\encryption_records.json

# See statistics
type data\key_statistics.json

# List encrypted files
dir encrypted\
```

---

## ❓ Troubleshooting

### "No data available yet"
**Solution**: Encrypt at least one file first!
- Go to Encrypt tab
- Upload and encrypt a file
- Then check Dashboard/Comparison tabs

### "undefined%" in Comparison
**Solution**: This appears when no files have been encrypted yet.
- Encrypt a file first
- Refresh the Comparison tab

### Charts Not Showing
**Solution**: 
- Make sure you've encrypted at least one file
- Click on the Dashboard or Comparison tab again
- Check browser console for errors (F12)

### Application Won't Start
**Solution**:
- Make sure Java 24 is installed
- Check if port 9999 is available
- Look for errors in the console

---

## 🎓 Learning Points

### What This Demonstrates

1. **Post-Quantum Cryptography**
   - Real ML-KEM (Kyber) encryption
   - NIST-standardized algorithm
   - Quantum-safe key encapsulation

2. **Size Trade-offs**
   - PQC keys are larger than classical
   - Visual comparison with RSA-2048
   - Understanding the overhead

3. **Hybrid Approach**
   - Combining AES + PQC
   - Best practices for quantum-safe encryption
   - Real-world implementation

4. **Practical Application**
   - File encryption/decryption
   - Metadata tracking
   - Statistics and visualization

---

## 🚀 Next Steps

### After Your First Encryption

1. **Try Different Algorithms**
   - Encrypt files with Kyber512, 768, and 1024
   - Compare the key sizes
   - See the security/size trade-offs

2. **Encrypt Multiple Files**
   - Build up your encryption history
   - Watch statistics accumulate
   - See charts populate with data

3. **Explore the Data**
   - Check the `data/` directory
   - View JSON files
   - Understand the metadata structure

4. **Test Decryption**
   - Click "Decrypt" button on a record
   - Verify file integrity
   - See the complete workflow

---

## 📚 Additional Resources

- **JAVA24_ML-KEM_GUIDE.md** - Technical details about ML-KEM
- **FILE_STORAGE_SOLUTION.md** - Storage architecture
- **README.md** - Project overview

---

## ✅ Success Checklist

- [ ] Application started successfully
- [ ] Opened http://localhost:9999
- [ ] Uploaded a file
- [ ] Selected an algorithm
- [ ] Clicked "Encrypt File"
- [ ] Saw success message
- [ ] Checked Records tab (file listed)
- [ ] Checked Dashboard tab (statistics showing)
- [ ] Checked Comparison tab (chart displaying)
- [ ] Understood the size trade-offs
- [ ] Explored the `data/` directory

**Congratulations! You've successfully demonstrated post-quantum cryptography!** 🎉

---

## 💡 Pro Tips

1. **Start with Kyber768** - Good balance of security and size
2. **Encrypt multiple files** - See statistics accumulate
3. **Compare algorithms** - Encrypt same file with different algorithms
4. **Check the JSON files** - Learn the data structure
5. **Try decryption** - Complete the full workflow

**Enjoy exploring post-quantum cryptography!** 🔐✨
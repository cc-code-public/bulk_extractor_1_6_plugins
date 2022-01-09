# bulk_extractor_1_6_plugins
Digital currency plugins for bulk_extractor version 1.6.0  
Predecessors have not been tested!

If you are looking for the 2.0 versions: https://github.com/cc-code-public/bulk_extractor_2_0_plugins

Included:
-------------------------------------------------
All plugins are designed to be used offline. All verification processes are implemented in the plugins themselves.

* bitcoin:
  * P2PKH and P2SH verified by sha256 checksum 
  * P2WPKH verified by bech32 checksum
 
* monero:
  * Standard-Address
  * Subaddress
  * Integrated-Address
all verified by Keccak-f[1600] (FIPS202_SHA3_256()) checksums

* mnemonic:
  * BIP-0039
  * Electrum Wallets (> version 2.0)
only englisch dictionaries and verified by HMAC-SHA-512

* hardware wallets:
  * supported hardware wallets: Trezor, Trezor v2, Ledger HW.1 / Nano, 'Ledger Blue /  Nano S / Aramis / HW.2 / Nano X, coinkite, digitalbox / bitbox, safe-t, keepkey
  * Windows Registry format "VID_XXXX&PID_XXXX"
  * Linux log format "XXXX:XXXX"

* domains:
  * Search against a SECONDLEVEL.TOPLEVEL domain list (domains_list.csv)
The file has to be located in the current execution path
 
* tor addresses:
  * v2 no verification possible
  * v3 verified by sha3-256 checksum
 

Installation for Ubuntu 18 LTS - Ubuntu 20 LTS:
-------------------------------------------------

sudo apt install git  
sudo apt install sleuthkit libafflib-dev libewf-dev  
(Others as require. For example: sudo apt install libsqlite3-dev)  

mkdir ~/Development  
cd ~/Development  
git clone https://github.com/simsong/bulk_extractor.git  
(INFO: bulk_extractor version 1.6.0)  
cd bulk_extractor  
bash etc/CONFIGURE_UBUNTU18LTS.bash  
mv plugins/Makefile.am plugins/Makefile.am.bak  


cd ~/Development  
git clone https://github.com/cc-code-public/bulk_extractor_plugins.git  
cd bulk_extractor_1_6_plugins  
cp -R extern ~/Development/bulk_extractor/plugins  
cp Makefile.am scan_bitcoin.flex scan_domains.flex scan_hwallets.flex scan_mnemonics.flex scan_monero.flex scan_torurls.flex ~/Development/bulk_extractor/plugins  

cd ~/Development/bulk_extractor/  
bash bootstrap.sh  
./configure  
make  

cd ~/Development/bulk_extractor/plugins  
bash bootstrap.sh  
./configure  
make plugins  

-------------------------------------------------

**And it is DONE!**  
To use the plugins just follow the bulk_extractor instructions:
1. Default dirs for plugins include /usr/local/lib/bulk_extractor, /usr/lib/bulk_extractor and BE_PATH environment variable.
Therefor add the ~/Development/bulk_extractor/plugins folder as BE_PATH environment variable or copy the .so files to one of the aforementioned folders.
2. Use the P parameter to hand over the ~/Development/bulk_extractor/plugins folder

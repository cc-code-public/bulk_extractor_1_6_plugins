# bulk_extractor_plugins
Digital currency plugins for bulk_extractor version 1.6.0  
Predecessors have not been tested!


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
cd bulk_extractor_plugins  
cp -R extern ~/Development/bulk_extractor/plugins  
cp Makefile.am scan_bitcoin.flex scan_domains.flex scan_hwallets.flex scan_mnemonics.flex scan_monero.flex ~/Development/bulk_extractor/plugins  

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

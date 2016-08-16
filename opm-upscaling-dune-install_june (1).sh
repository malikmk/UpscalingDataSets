#!/bin/bash

#!/bin/bash

#!/bin/bash

#General Packages

#Make opm directory if does not exist
directory="opm"
    if [ -d "$directory" ]
    then
        echo "$directory directory already exists."
    else
        mkdir opm/
        echo "$directory created."       
    fi

#Change dir to opm/
cd opm/

#Universe Package Add Repo
sudo apt-add-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
sudo apt-get install -y libdpkg-perl=1.17.5ubuntu5

sudo apt-get update
sudo apt-get autoclean
sudo apt-get lean
sudo apt-get autoremove

sudo apt-get install -y build-essential g++ gfortran #cmake cmake-data util-linux

#Documentation Packages
sudo apt-get install -y doxygen ghostscript texlive-latex-recommended pgf
#read -p "CHK POINT 2....."
#Version Control
sudo apt-get install -y git

#Basic libraries necessary for both DUNE and OPM
sudo apt-get update
sudo apt-get install -y automake
sudo apt-get install -y libsuperlu3-dev libsuitesparse-dev #libjsonrpccpp-dev libboost1.54-all-dev
sudo apt-get install -y cmake cmake-data util-linux


#----------------------------------------------------------
# Installing Boost
#----------------------------------------------------------
# Inform the user about the next action
echo "Downloading and installing Boost 1.55..."
# Constant values definitions
#FOLDER_NAME="Boost1.55"
# Create a new folder for storing the source code
#mkdir ${FOLDER_NAME}
# Change directory
#cd ${FOLDER_NAME}
# Download source code
wget http://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.bz2
# Extract archive
tar xvfo boost_1_55_0.tar.bz2
# Change directory
cd boost_1_55_0
# Run the script which prepares Boost's build process
sudo  ./bootstrap.sh --with-libraries=atomic,chrono,context,coroutine,date_time,exception,filesystem,graph,graph_parallel,iostreams,locale,log,math,mpi,program_options,random,regex,serialization,signals,system,test,thread,timer,wave

#prereqs for libboost iostreams
sudo apt-get install libbz2-dev

# Compile the project
sudo ./b2 toolset=gcc cxxflags=-std=gnu++0x
# Add the Boost libraries path to the default Ubuntu library search path
#sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/boost.conf'
# Update the default Ubuntu library search paths
#sudo ldconfig
# Return to the parent directory
cd ../
# Inform user that Boost 1.55 was successfully installed
echo "Boost 1.55 was successfully installed."

export BOOST_ROOT=~/opm/boost_1_55_0
export BOOST_LIBRARYDIR=~/opm/boost_1_55_0/stage/lib
export BOOST_INCLUDEDIR=~/opm/boost_1_55_0/boost

#------------------------------------------------------------
#Ubuntu add-apt-repo dependencies
sudo apt-get install -y python-software-properties

#Necessary Backports
sudo add-apt-repository -y ppa:opm/ppa sudo apt-get update
sudo apt-get install -y libtinyxml-dev

sudo apt-get install -y software-properties-common
#sudo add-apt-repository ppa:george-edison55/cmake-3.x -y
#sudo apt-get update   
#sudo apt-get install -y cmake

sudo add-apt-repository -y ppa:opm/ppa
sudo apt-get update

sudo apt-get install -y libopenblas-dev libdune-common-dev libdune-geometry-dev libdune-grid-dev libdune-istl-dev libsuitesparse-dev

#Install OpenMPI
sudo apt-get install -y software-properties-common
sudo apt-cache search opm-simulators
sudo apt-get install -y openmpi-bin
sudo apt-get install -y libopm-simulators-bin

#INSTALL ERT

#directory="ert"
    if [ -d "$directory" ]
    then
        echo "$directory directory already exists."
    else
#        #mkdir ert/
        git clone https://github.com/Ensembles/ert.git
        echo "$directory downloaded."       
    fi
cd ert/
directory="Build"
    if [ -d "$directory" ]
    then
        echo "$directory directory already exists."
    else
        mkdir build/
        echo "$directory created."       
    fi

cd build/


#continue installing ERT
cmake ../devel
make
make install
sudo make install
cd ../../


echo "DONE WITH ERT"
#read -p "CHK POINT 11....."
#pwd

##INSTALL DUNE

sudo add-apt-repository ppa:opm/ppa -y
sudo apt-get update
#sudo apt-get install -y libdune-common-2.3.1
#sudo apt-get install -y libdune-istl-dev
#sudo apt-get install -y libdune-common-dev
sudo apt-get install -y libdune-cornerpoint1
#sudo apt-get install -y libdune-geometry-2.3.1
#sudo apt-get install -y libdune-geometry-dev
#sudo apt-get install -y libdune-grid-2.3.1
sudo apt-get install -y libdune-localfunctions-dev
#read -p "CHK POINT 12....."

		modules='opm-common opm-parser opm-material opm-output opm-core opm-grid opm-simulators opm-upscaling eWoms'


#		$count = 0
echo "==============================="
		 #git clone https://github.com/OPM/opm-data.git
		 gitmodulelink='git clone https://github.com/OPM/'
		 gitext='.git'
		 for module in ${modules}; do
		 if [ -d "$module" ]
		 then
		 echo "$directory directory already exists."																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																
		 else 
			${gitmodulelink}${module}${gitext}
			echo "inside..."
			mkdir ${module}/build		 	
			cd ${module}/build
		 	cmake -DUSE_MPI=ON -DCMAKE_BUILD_TYPE=RELEASE ../
			nice make -j 4
		 fi
		 cd ../../
		 #read -p "CHK POINT 13....."
		 done






cd

cd opm/opm-upscaling
git clone https://github.com/malikmk/UpscalingDataSets.git
cd UpscalingDataSets
tar -xzvf model.grdecl.tar.gz
cd ../
mpirun -mca btl ^openib -np 1 ./build/bin/upscale_relperm ./UpscalingDataSets/model.grdecl ./UpscalingDataSets/rock{1..4}.txt > results.txt

#nice mpirun -np 12 --bind-to core ./build/bin/upscale_relperm ./Files/model.grdecl ./Files/rock1.txt ./Files/rock2.txt 




#Change dir to home
cd 
cd opm
#sudo rm -r opm-*
cd


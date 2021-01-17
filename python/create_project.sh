# description
echo "Create a python framework"

# set variable(s)
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# CREATE PROJECT DIRECTORY
echo =====================================================
re="*[^[:alnum:]/]*"

cd ../../
echo "Your current directory is: $PWD"
read -p "Enter absolute path to the project: " projectAbsolutePath

# Check if string is empty using -z
if [[ -z "$projectAbsolutePath" ]]; then
   printf '%s\n' "You must enter a project path"
   exit 1
# Check if valid folder path
elif [[ ! "$projectAbsolutePath" == *[^[:alnum:]/]* ]];  then
  echo "Project name must be alphanumeric"
  exit 1
# check if starts with /
elif [[ $projectAbsolutePath != '/'* ]]; then
  echo "You must provide the absolute path"
  exit 1
# check if path already exists
elif [ -d "$projectAbsolutePath" ]; then
  echo "Project already exists"
  exit 1
else
  echo "Creating directory $projectAbsolutePath..."
  mkdir -p $projectAbsolutePath
fi


# CLONE FRAMEWORK PROJECT FROM GIT
echo ==========================================================
cd $projectAbsolutePath
git init
read -p "Enter Git Username: " gitUserName
read -p "Enter Git Password: " gitPassword
read -p "Enter Git Branch of Framework: " frameworkBranch
git clone -b development "https://${gitUserName}:${gitPassword}@github.com/${gitUserName}/python_application.git"


# COPY IN VERSION OF PROJECT
echo ==========================================================
# Select version of the script
cd python_application
echo "Select version of the framework you would like to run:\n"
select version in v[0-9]*; do test -n "$version" && break; echo ">>> Invalid Selection"; done

# add folders to keep in an array
items_to_keep=()
items_to_keep+=("$version")
items_to_keep+=(".gitignore")

for i in "${items_to_keep[@]}"
do
   mv $i ../
done

cd ../
rm -rf python_application


# SELECT FRAMEWORK NECESSARY FOR PROJECT
echo ==========================================================
# run script to create that version of the project
echo "customise $version of python framework"
/bin/bash $currentDir/$version/customise_project.sh $version


# END
echo ==========================================================
echo -n "Are you happy with your project (y/n)? "
read answer
if [ "$answer" != "${answer#[Nn]}" ] ;then
    cd ../../
    echo "Deleting project $projectAbsolutePath"
    rm -rf $projectAbsolutePath
else
    echo "Project $projectAbsolutePath has been created...happy coding"
fi

exit 0
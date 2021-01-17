# description
echo "Customise python project $PWD"

# set variable(s)
currentDir=$PWD

# PROJECT TYPE (API OR SCRIPT)
echo ==========================================================
echo "Please select type of project you would like to run:\n"
cd $1/core/entities/application/
select project_type in *; do test -n "$project_type" && break; echo ">>> Invalid Selection"; done

echo "Deleting other project types..."
find ./ -mindepth 1 ! -regex "^./${project_type}\(/.*\)?" -delete

if [ "$project_type" != "api" ]; then
    echo "Deleting routes...."
    cd $currentDir
    rm -rf ./$1/core/entities/routes
fi

echo "Updating environment variables.."
echo -e "\nPROJECT_TYPE=${project_type}" >> $currentDir/$1/.env


# PROJECT SERVICES (THIRD PARTY INTEGRATIONS)
echo =======================================================================
echo "Please select the external services you would like to connect with:\n"
# Array for list of services available
echo $currentDir
cd $currentDir
services=()
services=(./$1/core/services/*/)    # This creates an array of the full paths to all subdirs
services=("${services[@]%/}")            # This removes the trailing slash on each item
services=("${services[@]##*/}")          # This removes the path prefix, leaving just the dir names

# Array for storing the user's choices
choices=()

# display choices on new lines
COLUMNS=12
select choice in "${services[@]}" Finished
do
  # Stop choosing on this option
  [[ $choice = Finished ]] && break
  # Append the choice to the array
  choices+=("$choice")
  echo "$choice, got it. Any others?"
done

# Array for folders to be deleted (i.e. difference between services and choices)
differences=(`echo ${services[@]} ${choices[@]} | tr ' ' '\n' | sort | uniq -u `)

echo "Deleting unecessary services.."
for i in "${differences[@]}"
do
   rm -rf ./$1/core/services/$i
   rm -rf ./$1/core/resources/$i
done


# PROJECT TEMPLATES
echo =======================================================================
cd $currentDir
echo -n "Keep the examples on how to use the services (y/n)? "
read answer
if [ "$answer" != "${answer#[Nn]}" ] ;then
    rm -rf ./$1/core/entities/examples/services
fi

echo -n "Keep the examples on how to use the common scripts (y/n)? "
read answer
if [ "$answer" != "${answer#[Nn]}" ] ;then
    rm -rf ./$1/core/entities/examples/common
fi


# PROJECT DATABASE
echo =======================================================================

# activate virtual env
# install dependencies pylint etc
# if api app then xyz
# run test
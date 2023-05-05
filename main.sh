PS3='  Please enter your choice: '
options=("Create Database user." "Delete Database User."  "Create new Database." "Delete an existing Database."
         "Create A new Table inside Database." "Insert A New Row in a Table." "Select and delete Data from Table.")


select x in "${options[@]}"
 do
     if [[ $x == "Create Database user."  ]]
       then
          v_username=`whoami`
          user_check=`grep  -w $v_username DB_admins.db`
          if [[ $v_username == $user_check  ]]
            then
               echo "-------------------------------------- "
               echo "You are the admin and you can add user "
               echo "-------------------------------------- "

               echo "--------------------- "
               echo " Enter the user name  "
               echo "--------------------- "
               read new_username
		new_check=`grep -w $new_username DB_admins.db`
                                                                                                   
                if [[ $new_username ==  $new_check  ]]
                   then
                       echo "----------------------------- "
                       echo  "$new_username already exists "
                       echo "----------------------------- "
                       . main.sh     
                else
                       echo $new_username >> DB_admins.db
                       echo "---------------------------------- "
                       echo "$new_username created successfully "
                       echo "---------------------------------- "
                       . main.sh
                fi
	else
        echo "------------------------------------------------- "
        echo "you cannot add user  becouse you are not the admin"
        echo "------------------------------------------------- "
fi
fi


###################################################################################
###################################################################################



if [[ $x == "Delete Database User."  ]]
    
    then
      
       v_username=`whoami`
       user_check=`grep  -w $v_username DB_admins.db`
          
            if [[ $v_username == $user_check  ]]
               then 
		   echo "  "
                   echo "-------------"   
                   echo "Current users"
	           echo "-------------"
         	   cat DB_admins.db
                   echo "------------------------------"
		   echo " enter username to be deleted "
                   echo "----------------------------- " 
    		   read del_user
                    
	           new_check=`grep -w $del_user DB_admins.db`

		   if [[ $del_user == "oracle"  ]]
		       then
                           echo "---------------------------- " 	
			   echo "You can't delete user oracle "
                           echo "---------------------------- "
                           . main.sh
 
	           elif [[ $del_user ==  $new_check  ]]
                       then 
			   sed -i "s/$del_user//" DB_admins.db
	                   echo "---------------------"
                           echo " users after updated "
                           echo "---------------------"
			   cat DB_admins.db
                   else
			   echo "------------------------------------------- "
                           echo "User $del_user not considered as Admin User"
                           echo "------------------------------------------- "
                           . main.sh
      	           fi				  
            else
                echo "---------------------------------------------------- "
                echo "You cannot delete user  becouse you are not the admin"
                echo "---------------------------------------------------- "
                . main.sh 
            fi

fi




##########################################################################
#########################################################################



if [[ $x == "Create new Database."  ]]

then
	v_username=`whoami`
        user_check=`grep  -w $v_username DB_admins.db`
        if  [[ $v_username == $user_check  ]]

           then
                echo " ------------------------------ "
		echo " Enter Database Name: "
                echo " ------------------------------ "
		read DB_name
                DB_check=`find ./DataBases -type d -name "$DB_name" | cut -d/ -f3`
                 if [[ $DB_name == $DB_check ]]
                   then
                   echo " ------------------------------ "
                   echo " This DataBase already exsit: "
                   echo " ------------------------------ "
                   
. main.sh
                 else
                    mkdir ./DataBases/$DB_name
                    touch ./DataBases/$DB_name/owner.txt
                    echo " $v_username " >> ./DataBases/$DB_name/owner.txt
                    echo " ------------------------------ "
                    echo " DataBase  created succsefully. "
                    echo " ------------------------------ "
                    . main.sh 
                 fi
        
         else
            echo " ------------------------------ "
            echo " You are not one of the admins: "
            echo " ------------------------------ "          
            . main.sh
	fi


fi


#######################################################################
#######################################################################

if [[ $x == "Delete an existing Database." ]] 
 then 

        v_username=`whoami`
        user_check=`grep  -w $v_username DB_admins.db`
 
          if  [[ $v_username == $user_check  ]]
	     then 
	       ls  DataBases 
                  echo "------------------------------------ "
	          echo "Enter Name of Database to be deleted:"
                  echo "------------------------------------ "
                  read del_D
                
                  owner_check=`cat ./DataBases/$del_D/owner.txt`
	          var=`echo $owner_check`			
	           
                     if [[ $v_username == $var ]]
	                then
			   
			   rm -rf ./DataBases/$del_D 
                           echo " ---------------------------- "
                           echo "DataBase Deleted Successfully:"
                           echo "------------------------------" 
                    else
                           echo "-----------------------------------------"
                           echo "You are not the owner of '$del_D' databse"
                           echo "-----------------------------------------"
                           . main.sh
                    fi
	   else
               echo " ----------------- "
               echo " You are not admin "
               echo " ----------------- "
               . main.sh	
          fi
fi


#############################################################
############################################################



if [[ $x == "Create A new Table inside Database." ]]
  then
        v_username=`whoami`
        user_check=`grep  -w $v_username DB_admins.db`

       if  [[ $v_username == $user_check  ]]
          then
            ls  DataBases
            echo " ------------------------------------------------- "
	    echo "Enter the of Database you want to add a table in it : "
            echo " ------------------------------------------------- "
            read db_name
 
            owner_check=`cat ./DataBases/$db_name/owner.txt`
            var=`echo $owner_check`
                if [[ $v_username == $var ]]
                    then
                    echo " ------------------------------------------- "
                    echo " Enter the table name with .table extension :"
                    echo " ------------------------------------------- "  
       		    read table_name
		  
                    
                    table_name_check=`find DataBases/$db_name  -type f -name "$table_name" | cut -d/ -f3`
		    var2=`echo $table_name_check`  
		        
                          if [[  $table_name == $var2 ]] 
	       		      then
                                  echo "------------------------- "
				  echo "This table already exist: "
                                  echo "------------------------- "
                                             
                          else 
			          touch DataBases/$db_name/$table_name
				  echo "enter number of columns"
				  read col_n
 			          count=1
					while [[ $count -le $col_n ]]
                                             do
                                                if [[  $count -lt $col_n ]]
                                                     then
                                                         echo -n  "enter name of col $count:  "
                                                         read name
                                                         echo -n "$name," >> DataBases/$db_name/$table_name
                                                else
                                                         echo -n  "enter name of col $count:  "
                                                         read name
                                                         echo -e -n "$name\n" >> DataBases/$db_name/$table_name
                                                        
                                                fi
                                                 ((count=count+1))                                               
                                             done
				echo "------------------- "  
				echo " $table_name created"
		                echo "-------------------- "
                                . main.sh 
                         fi
               fi
        fi
fi

########################################################################
#######################################################################

if [[ $x == "Insert A New Row in a Table." ]] 
 then  
        v_username=`whoami`
        user_check=`grep  -w $v_username DB_admins.db`

             if  [[ $v_username == $user_check  ]]
               then
                     echo "------------------------------------ "
                     ls  DataBases
                     echo "------------------------------------ "
                     echo " Enter your Database to work on it : "
                     echo "------------------------------------ "
                     read DB_name
 
                     owner_check=`cat ./DataBases/$DB_name/owner.txt`
                     var=`echo $owner_check`
                         if [[ $v_username == $var ]]
                             then
                               cd DataBases/$DB_name
                               ls *.table
                               echo "---------------------------------- "
                               echo "Enter table name to insert in it : "
                               echo "---------------------------------- "
                               read table_name
                               head -1 $table_name                        
                              
                               column_num=`head -1 $table_name | grep -o "," | wc -l` 
                               ((column_num=column_num+1))
                               echo "-------------------------------------------------- "                          
                               echo " number of columns for this table is $column_num : "
                               echo " Please insert $column_num values only : " 
                               echo "-------------------------------------------------- "     
                               count=1 
			        
                                  while [[ $count  -le $column_num  ]] 
			              do
                             	        if [[ $count  == 1 ]]
				            then
					       echo -n  "enter name of col $count:  "
                                               read col_var  
				   	 
                                               unique_check=`cut -d, -f1 $table_name | grep $col_var`

					           if [[ -z $unique_check ]]
                                                       then 
                                                       echo -n "$col_var," >> $table_name
                                                   else 
						       echo "This ID already exist! "
						       cd ../../
                                                       break 
                                                   fi

                                        elif [[ $count -lt $column_num ]]
                                              then
           			                echo -n  "enter name of col $count:  "
                                                read col_var
                                                echo -n "$col_var," >> $table_name
                                        else
                                                echo -n  "enter name of col $count:  "
                                                read col_var
                                                echo -e -n "$col_var\n" >> $table_name
                                                cd ../../

                                          fi 
                                          ((count++))
			                done  
                             else	
			       echo "-------------------------------------- "
                               echo " you are not the owner of this database" 
		               echo "-------------------------------------- " 
                        fi

                  else
                     echo "---------------- "
                     echo "You are not admin"
                     echo "---------------- "
               fi
    fi                                

######################################################################################
######################################################################################

if [[ $x == "Select and delete Data from Table." ]]
     then 
          
            ls DataBases
            echo "Enter the name of Database you want to work in  : "
            read db_name

		 cd DataBases/$db_name
	         ls *.table
                 cd ../../
  
			echo " Enter the name of the table you want: "
			read table_name
                    
                 
                        PS3='enter the option:  '
                        choices=("Show all the available content of certain table : " "Search in a certain table " 
                                 "Delete Row from Table." "Return to main function")
                         
                        select y in "${choices[@]}"
			  do 
                            if [[ $y == "Show all the available content of certain table : " ]]			 
                                then 
				   cat DataBases/$db_name/$table_name
                            fi 
                            
                            if [[ $y == "Search in a certain table " ]]	
                                then
			           echo " Enter the string You want to search by it : "
			           read word
				     if [[ -z `grep -i $word DataBases/$db_name/$table_name` ]]
					then 
					echo " This word not exsit: "
                                     else
                                        grep -i $word DataBases/$db_name/$table_name
                                      
                                     fi 
                            fi 
                            
                            if [[ $y == "Delete Row from Table." ]]
                                then
                                   cat DataBases/$db_name/$table_name
                                   echo " Enter the word to delete row: "
                                   read word
                                   sed -i "/$word/d" DataBases/$db_name/$table_name
                                   echo "----------------------"
                                   echo " table after updated " 
                                   echo "---------------------" 
                                   cat DataBases/$db_name/$table_name 

			    fi 


                            if [[ $y == "Return to main function" ]]
	                       then 
                                  . main.sh 
                            fi
		         
                         done
fi




done














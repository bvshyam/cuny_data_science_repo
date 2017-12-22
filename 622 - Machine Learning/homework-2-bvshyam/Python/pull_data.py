# This program uses Kaggle. It automatically fetchs the particular competition training and test dataset. It is tested with Titanic dataset. Link https://www.kaggle.com/c/titanic.


import requests
from bs4 import BeautifulSoup
import pandas as pd
import mechanicalsoup
import getpass
import os



# Updated the credentials into a text file

def update_cred(cred_file_write,username,pwd):
    """This function stores the credentails in a file in secret location"""
    cred_file_write.seek(0)
    cred_file_write.truncate()
    cred_file_write.write(username+'\n')
    cred_file_write.write(pwd)
    cred_file_write.close()
    
    print("Credentials Updated in secret location!")


# Authenticate a user into Kaggle


def authenticate():
    """This function is used to get the login details of the Kaggle user."""
    
    try:
        #Create instance of Mechnaicalsoup
        browserm = mechanicalsoup.Browser()
        cred_file = open(cred,'r')
        
        #Login to Kaggle Login page
        loginpage = browserm.get("https://www.kaggle.com/account/login")
        form = loginpage.soup.form
        
        #Credentials on login page
        form.find("input",{"name":"UserName"})["value"] = str(cred_file.readline()).strip()
        form.find("input",{"name":"Password"})["value"] = str(cred_file.readline()).strip()
        response = browserm.submit(form, loginpage.url)
        brb = mechanicalsoup.Browser(session=browserm.session)
        cred_file.close()
    except:
        print("Error while logging into Kaggle website. Page structure would have changed")
        
    return(brb)


# Download and save the file in local server


def download_file(project,file_type):
    """This function is used to download the file for that competition. Need to be enrolled for that competition to use this file"""
    try:
        
        # Get the file Data for that competition
        download = brb.get('https://www.kaggle.com/c/{}/download/{}.csv'.format(project,file_type))
        
        file_path = '../Data/'+file_type+'.csv'
        
        # Create a new file in local path
        with open(file_path,'wb') as csv_file:
            csv_file.write(download.content)
        print("{} {} file downloaded successfully".format(project,file_type))
    
    except:
        print("File download failed. File path or location would have changed")


# Main function which sets the folders and call other functions


if __name__=="__main__":
    
    # Create Folders if it does not exists
    if not os.path.exists('../credentials'):
        os.makedirs('../credentials')
    
    if not os.path.exists('../Data'):
        os.makedirs('../Data')
    
    cred = '../credentials/credentials.txt'
    
    # Get the Kaggle Credentials from the user
    username = input("Enter Kaggle username: ",)
    pwd = getpass.getpass("Enter Kaggle password: ")
    
    cred_file_write = open(cred,'w')
    
    # Update the credentials into the secret file
    update_cred(cred_file_write,username,pwd)
    
    print("Credentials is stored for {}".format(username,pwd) )
    
    brb = authenticate()
    
    # Download the files. Project and type of file as input
    download_file('titanic','train')
    download_file('titanic','test')


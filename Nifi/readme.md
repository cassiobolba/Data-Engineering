## INSTALLING NIFI
1 - Open linux terminal  
2 - go to https://nifi.apache.org/download.html and get the version you want  
3 - right click and copy the link  

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/Nifi/img/binary_download_nifi.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>

4 - use the command:
```sh
# curl + paste the link copied + param output + specify the localtion and file name
curl https://archive.apache.org/dist/nifi/1.12.1/nifi-1.12.1-bin.tar.gz --output ~/cassio/nifi.tar.gz
```
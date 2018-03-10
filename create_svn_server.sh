1. svnadmin create /home/git/code/svn/svnrepos
2. vi conf/authz 
   [/]
   git = rw
3. vi conf/passwd
   git = secret
4. vi conf/svnserve.conf
   anon-access = read
   auth-access = write
   password-db = passwd
   authz-db = authz
   realm = /home/git/code/svn/svnrepos/
5. svnserve -d -r /home/git/code/svn/svnrepos
6. sudo iptables -I INPUT -p tcp --dport 3690 -j ACCEPT

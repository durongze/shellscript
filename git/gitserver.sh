id git
su
useradd git
passwd git
mkdir -p /home/git
chown git:git /home/git
pushd /home/git
mkdir repo.git
git init --bare repo.git
service ssh restart

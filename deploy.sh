git add . &&
git commit -m $1 &&
git push origin master &&
ssh root@164.132.193.242 <<EOF
cd aulahaskadsm &&
git pull origin master &&
stack build &&
lsof -i:80 -Fp | sed 's/^p//' | head -n -1 | xargs kill -9;
nohup stack exec aulahaskell > /dev/null
echo "deploy finished"
EOF
# ~/.ssh/config 파일 생성
cat <<EOF>> ~/.ssh/config
Host ${hostname}
  HostName ${hostname}
  IdentityFile ${identityfile}
  User ${user}
  ForwardAgent yes
EOF

# ~/.ssh/config 파일 퍼미션 설정
chmod 600 ~/.ssh/config
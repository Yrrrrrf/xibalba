## Deploy to EC2

### Build (local)
```bash
bun run --cwd apps/explorer vite build
```

### Ship
```bash
scp -i .balam.pem -r src/client/apps/explorer/build ubuntu@3.141.197.76:~/build
```

### Serve (remote)
```bash
ssh -i .balam.pem ubuntu@3.141.197.76
cd ~/build && bunx serve -s . -l tcp://0.0.0.0:4173
```

### Access on: [http://3.141.197.76:4173](http://3.141.197.76:4173)

# OpenSSH - transparent Multi-hop SSH

SSH through one host to get to another.

### Manually

- Specify the full domain name
- Use `-A` to enable 'agent forwarding' - this follows the request back to your machine and check it against your local ssh key.

```bash
  ssh -A host.com
  ssh -A machine1
  ssh -A machine2
```

You can chain the three commands together into one. By adding `-t` you force a pseudo-tty to be allocated giving you an interactive shell.

```bash
  ssh -A -t host.com ssh -A -t machine1 ssh -A machine2
```

### ProxyCommand

With `ProxyCommand` you can ssh directly to the machine. 

- This allows you to copy files to/from the machine directly without having to worry about the bits in-between.
- You can enable X-forwarding so any GUI program you start on 'machine2' can be displayed on you machine.
- Use GUI applications on your local machine to talk over ssh such as file browsers or sqldeveloper, [bcvi](http://sshmenu.sourceforge.net/articles/bcvi).
- You can forward other ports over ssh such as port 80 and view it locally on your browser `ssh machine2 -L 8282:127.0.0.1:80`.

Another way to automate connections through intermediate hosts is to add a 'ProxyCommand' to your SSH config (~/.ssh/config). (This requires the `netcat` package to be installed).

```bash
  Host host
    HostName host.com

  Host machine1
    ProxyCommand ssh -q host nc -q0 machine1 22

  Host machine2
    ProxyCommand ssh -q machine1 nc -q0 %h 22
```

- You can now type `host` instead of `host.com`
- 'machine1' will establish a normal ssh connection from host but uses `nc` to extend the connection port
- The third entry extends the connection to our target 'machine2'. The command `%h` is simply a shorthand that tells SSH to insert the target hostname (from the line above).

```bash
  ssh machine2
```

### Reusing Connections

Connections may take a second or two to establish - this delay can become annoying. If you have an SSH session running then a new connection for SCP can skip the connection setup phase.

- Create a folder to keep track of established connections `mkdir ~/.ssh/tmp`

Update your ssh config.

```bash
  ControlMaster auto
  ControlPath   /home/<username>/.ssh/tmp/%h_%p_%r
```

```bash
ssh-keygen 
truncate -s 10G hyper.raw
sudo podman run --privileged --rm --pid=host --security-opt label=type:unconfined_t -it -v /dev:/dev -v ./:/var/mnt/inst -v ~/.ssh:/var/mnt/ssh -v /var/lib/containers:/var/lib/containers:Z ghcr.io/bensmith/fedora-bootc-hypervisor:41 bash
```

```bash
bootc install to-disk --root-ssh-authorized-keys=/var/mnt/ssh/id_ed25519.pub --filesystem=ext4 --via-loopback --generic-image --wipe /var/mnt/inst/hyper.raw
```


All in one command
```bash
sudo podman run \
  --privileged \
  --rm \
  --pid=host \
  --security-opt label=type:unconfined_t \
  -it \
  -v /dev:/dev \
  -v ./:/var/mnt/inst \ 
  -v ~/.ssh:/var/mnt/ssh \ 
  -v /var/lib/containers:/var/lib/containers:Z \ 
  ghcr.io/bensmith/fedora-bootc-hypervisor:latest \
      bootc install to-disk \
      --root-ssh-authorized-keys=/var/mnt/ssh/id_ed25519.pub \
      --filesystem=ext4 \
      --via-loopback \
      --generic-image \
      --wipe \
      /var/mnt/inst/hyper.raw 
```



```bash
sudo podman run \
  --privileged \
  --rm \
  --pid=host \
  --security-opt label=type:unconfined_t \
  -it \
  -v /dev:/dev \
  -v ./:/var/mnt/inst \ 
  -v ~/.ssh/id_bootc_ed25519.pub:/var/mnt/ssh/id_ed25519.pub \
  -v /var/lib/containers:/var/lib/containers:Z \ 
  ghcr.io/bensmith/fedora-bootc-hypervisor:latest \
      bootc install to-disk \
      --root-ssh-authorized-keys=/var/mnt/ssh/id_ed25519.pub \
      --filesystem=ext4 \
      --generic-image \
      --wipe \
      /dev/sdb 
```





These mkdirs and mounts don't work automatically

```bash
sudo podman run \
  --privileged \
  --rm \
  --pid=host \
  --security-opt label=type:unconfined_t \
  -it \
  -v /dev:/dev \
  -v ~/.ssh/id_bootc_ed25519.pub:/var/mnt/ssh/id_ed25519.pub \
  -v /var/lib/containers:/var/lib/containers:Z \
  ghcr.io/bensmith/fedora-bootc-hypervisor:latest \
      mkdir -p /var/mnt/target && \
      mount /dev/sdb3 /var/mnt/target && \
      mkdir -p /var/mnt/target/boot && \
      mount /dev/sdb2 /var/mnt/target/boot && \
      bootc install to-filesystem \
      --boot-mount-spec=UUID=dd9ba5c5-a8f8-4ab7-9c35-2b0e3a99246b \
      --root-ssh-authorized-keys=/var/mnt/ssh/id_ed25519.pub \
      --generic-image \
      /var/mnt/target
```

bootc install to-filesystem --root-ssh-authorized-keys=/var/mnt/ssh/id_ed25519.pub --generic-image /var/mnt/target

bootc install to-disk --root-ssh-authorized-keys=/var/mnt/ssh/authorized_keys --generic-image --wipe --filesystem=ext4 /dev/nvme1n1

Import into libvirt

```bash
ssh root@192.168.122.22
adduser username
passwd username
usermod -aG wheel username
```
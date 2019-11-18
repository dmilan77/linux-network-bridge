#
- Install Vagrant and Virtualbox
https://www.vagrantup.com/docs/installation/
https://www.virtualbox.org/wiki/Downloads

- Test
```
vagrant init debian/stretch64 \
  --box-version 9.9.1
vagrant up
vagrant ssh

```

# If all look good
```
vagrant destroy
````

# Ansible playbook for trading machine

## Run playbook

```
ansible-playbook -i <IP>, main.yml
```

## Initial run

### AWS

```
ansible-playbook -i <IP>, -u ubuntu --private-key <KEY> main.yml
```

### Others with root access

```
ansible-playbook -i <IP>, -u root --ask-pass main.yml
```

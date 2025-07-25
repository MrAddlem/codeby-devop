# [Ansible role gitlab_runner](#gitlab_runner)

Install and configure gitlab-runner on your system.


## [Example Playbook](#example-playbook)

This example is taken from

```yaml
---
gitlab_runner_metrics_listen_address: "9252"

gitlab_runners:
  - name: "runner1"
    url: "https://gitlab.example.com/"
    registration_token: "TOKEN_1"
    executor: "shell"

  - name: "runner2"
    url: "https://gitlab.example.com/"
    registration_token: "TOKEN_2"
    executor: "docker"
    docker_image: "ubuntu:latest"
    ocker_privileged: true
    docker_network_mode: "bridge"
    request_concurrency: 5
```

## [Role Variables](#role-variables)

The default values for the variables are set in [`defaults/main.yml`](https://github.com/robertdebock/ansible-role-gitlab_runner/blob/master/defaults/main.yml):

```yaml
---
# defaults file for gitlab_runner

# The version of the GitLab runner to install.
gitlab_runner_version: "latest"

# Set the amount of concurrent jobs.
gitlab_runner_concurrency: "{{ ansible_processor_vcpus }}"

#Configuration of the metrics HTTP server
gitlab_runner_metrics_listen_address: "9252"

```
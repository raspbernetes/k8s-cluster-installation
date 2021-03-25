---
- name: 'restarting container runtime ({{ cri_plugin }})'
  systemd:
    name: '{{ cri_plugin }}'
    daemon_reload: true
    state: restarted
    enabled: true
  listen: 'restart cri'

- name: restart systemd-sysctl
  systemd:
    name: systemd-sysctl
    state: restarted

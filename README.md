# CIS Automated Hardening and Auditing Script for Oracle Linux-7




How to Use the Script:
To get started, simply execute the `start` file in a Linux environment:

```bash
sudo bash start
```


When you run this file, you will have two options:

1. **Auditing**
2. **Hardening**

Selecting the relevant option will initiate the corresponding process. During the execution, all items that comply with the CIS standard ([cisecurity.org]()) 
will be marked with "**PASSED**," while items that do not comply will be marked with "**FAILED**".
The index number of each item is specified in the output,These indexes derived from the relevant CIS benchmark index for the Linux operating system.
At the end, a summary of the performed tasks and their success rate will be displayed as a graphical report.

**Please Note:** The script must be executed by root access. If you run the script through a user without root access, the process will be aborted with an error message.
 
 
## Notes about starting the hardening Script

At the beginning of executing hardening script , you will be asked for three questions:

- The firewall will be enabled.
  
- The authentication profile and PAM configuration will be reset.
  
- Please ensure that the date and time are correct.
  

In the next step, your operating system version will be checked. If it does not match the defined version, you will receive an error message indicating that this script does not support your operating system version.
This is an important safety measure, if the operating system version is incompatible, running the script may lead to issues.

## Files and Directories

In the current directory of script files, a set of files and directories will be created, so it is recommended to execute the script in a separate directory.


#### Logs and backups descriptions

By running the **Auditing** process (Caliper), you will generate the following files:

- `log_$date` file with a timestamp, containing all the checks performed. In this file, items that meet the desired criteria are marked in green and tagged with a "Passed" sign. Other items are marked in red with an "Error" sign.
  
- A `log_errors_$date` file containing only the items that did not meet the desired criteria and require correction. By slightly rearranging these logs, you can forward them to other software for analysis.
  

By running the **Hardening** process(Pliers), you will generate the following files and directories:

- `hrdlog_$date` file contains all the items processed during the hardening phase.
  
- A directory named as the server hostname, will be created in the current directory.
  
  This directory contains:
  
  1. Logs of deleted packages, logs of installed packages, access logs of packages, and other related changes with corresponding names.
  2. `read_manual_fix.txt` : contains explanations and guidance for items that require administrative decisions and must be performed manually.
  3. `backup` directory that contains important configuration file backups, which have been edited during program execution.

Reviewing these items will enable you to restore system components to their previous state.

**Please note that** this script will make changes to your system and may have some consequences. Please run this script first in a testing environment, before executing on operational systems.

---

This is the initial version and future versions will address proposed items and issues.

Feel free to ask if you need any additional changes or further assistance!

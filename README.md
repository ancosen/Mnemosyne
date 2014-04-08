Mnemosyne
=========

## <a name='TOC'>Table of Contents</a>

  1. [Mnemosyne](#Mnemosyne)
  1. [Actual State](#State)
  1. [Usage](#Usage)
  1. [Examples](#Examples)
  1. [Contributing](#Contributing)
  1. [License](#License)

## <a name='Mnemosyne'>Mnemosyne</a>

Mnemosyne is a simple script to automate any backup on your system by adding an associated crontab rule

## <a name='State'>Actual State</a>

The development of Mnemosyne is at the beginning and only the first features are available. If you have improvement or new features ideas feel free to open a new issue.

## <a name='Usage'>Usage</a>

```shell
Backup folder or file in a specific path with associated crontab rule using rsync

OPTIONS:
   -h      Show this message
   -s      File or folder to backup
   -d      Backup destination directory
   -c      Add a crontab rule to this command
   -a      Archive mode
   -u      Update mode
   -r      Recursive mode
   -l      Copy symlinks as symlinks
   -p      Preserve permissions
   -g      Preserve groups
   -t      Preserve modification times
   -o      Preserve owner
   -v      Verbose
   -I      Don't skip files that match size and time
   -O      Omit directories from -t
```

## <a name='Examples'>Examples</a>

Suppose you want to backup your home directory every 12 hours in a specific folder. With Mnemosyne this is possible with a simple command

```shell
		./mnemosyne.sh -s /home/ -d /media/username/disk/ -c '0 0,12 * * *'
```
If you get your crontab rules you'll now find:

```shell
		0 0,12 * * * rsync -r /home/ /media/username/disk/
```

## <a name='Contributing'>Contributing</a>

Feel free to contribute by testing, opening issues and adding/changing code

## <a name='License'>License</a>

Copyright 2014 Andrea Cosentino and Contributors

Licensed under the GNU General Public License, Version 3.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at https://www.gnu.org/copyleft/gpl.html

![alt tag](https://www.gnu.org/graphics/gplv3-127x51.png)

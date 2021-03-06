# Nim Fortune

A version of fortune built with Nim, and thus runs on Windows. Fortune is a BSD program which prints witty messages to the console.

```
~\s\r\fortune> fortune
Computers can figure out all kinds of problems, except the things in
the world that just don't add up.
```

## Features 
  - Statically linked executable with small footprint
  - Takes an input an integer to print a specific fortune. No in-built randomness
  - Lightning fast, under 20ms to print

## Requirements
You will need the Nim compiler, and optionally GNU strip. That is all.

## Building

To create, run
```
nim buildFortune
```

This will create an executable called `fortune.exe`, or `fortune` depending on your OS. This executable has the fortunes location built in, so you can move it around as you wish. However, the autogenerated `fortunes/` folder cannot be moved around.

## Supplying your own fortune file

Simply replace `fortune.txt` with your own file. The format of a fortune looks like this:

```
fortune1 CRLF
% CRLF
fortune2
```

## How it works

The fortune.txt file is preprocessed to create a file called "header.txt", and a folder called `fortunes/`. In this folder you will find the fortunes, split into page-sized files.

The reason why it is split into page sized files to is reduce load time. Naive implementations of fortune read the whole file into memory and then split it, but that is inefficient. Instead, we preprocess the list of fortunes into files that are about a single OS page. Then, when the user requests a fortune, we simply open the appropriate file. 

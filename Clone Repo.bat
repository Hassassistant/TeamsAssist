@echo off
cd C:\
git clone https://github.com/Hassassistant/TeamsAssist.git
move TeamsAssist\Scripts .
rd /s /q TeamsAssist
start Scripts\Settings.ps1
start Scripts

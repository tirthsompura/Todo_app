# TodoApp - Flutter

A modern Flutter Todo app built with Bloc and Hive.  Includes a timer for each task, start/pause/stop controls, a clean bottom sheet form for add/edit, and a full details page with live tracking

<img src="https://github.com/user-attachments/assets/924c0906-56ec-4679-af5c-1a2517fce8af" width="165">
<img src="https://github.com/user-attachments/assets/38d643a3-fc6a-42ec-911e-e9c61e646fe2" width="165">
<img src="https://github.com/user-attachments/assets/9e36c22c-4152-43ea-a0f7-477db6354837" width="165">
<img src="https://github.com/user-attachments/assets/90aac089-6c20-454d-9bf9-dc25f93911d0" width="165">

## Features

#1. Todo List Page (Home Screen)
- Displays all todos with title, short description, status, timer.
- Supports start, pause, stop, mark done, and delete.
- Shows live running timer for active todos.
- Opens Add/Edit Todo Form in a bottom sheet.

#2. Add / Edit Todo (BottomSheet)
- Add new todos or edit existing ones.
- Input fields: Title, Description
- Time (minutes & seconds) — up to 5 minutes
- Validates input before saving.
- Saves todo to local database (Hive).

#3. Todo Details Page
- Shows full information about the selected todo.
- Displays live running timer.
- Includes Play, Pause, Stop controls.
- Provides an Edit button (opens bottom sheet).

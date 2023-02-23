import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/db/notes_database.dart';
import 'package:notes/model/note.dart';
import 'package:notes/pages/Note_details_page.dart';

import '../widgets/note_card_widget.dart';
import 'Add_edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 14),
        ),
        actions:const [
           Icon(
            Icons.search,
          ),
           SizedBox(
            width: 12,
          )
        ],
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text(
                      'no notes',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                  : buildNotes()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddEditNotePage()));
          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() => MasonryGridView.count(
        crossAxisCount: 4,
        itemCount: notes.length,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: ((context, index) {
        return  GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: notes[index].id!)));
              refreshNotes();
            },
            child: NoteCardWidget(note: notes[index], index: index),
          );
        }),
      );
}

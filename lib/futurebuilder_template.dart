                
                
                FutureBuilder(
                    future: getChatList(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Error");
                        } else {
                          return Container();
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
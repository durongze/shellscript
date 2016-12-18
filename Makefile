EXEC = exec
OBJS = tcp_server.o main.o

CC = gcc
CXX = g++

CFLAGS = 

CXXFLAGS = 

VPATH = src src/tcp 

INCPATH = -Isrc/tcp
LIBPATH = -Lsrc/tcp

LIBS = -lpthread 

$(EXEC):$(OBJS)
	$(CXX) $(INCPATH) $(LIBPATH) -o $(EXEC)  $(OBJS) $(LIBS)

%.o:%.cpp
	$(CXX) $(INCPATH) $(LIBPATH) -o $@ -c $< $(LIBS) 

clean:
	$(RM) $(OBJS)

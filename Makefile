exec = exec
platform = linux
srcs = $(wildcard *.cpp)
objs = $(patsubst %.cpp,out/$(platform)/%.o,$(srcs))

CC = gcc
CXX= g++
RM = rm 


LIB_ROOT=${HOME}/opt
CPPREST_INC=$(shell echo ${cpprest_home}/Release/include)
CPPREST_LIB=$(shell echo ${cpprest_bin})

SSL_ROOT=${LIB_ROOT}/openssl-1_1_1
ZLIB_ROOT=${LIB_ROOT}/zlib-1_2_11
BOOST_ROOT=${LIB_ROOT}/boost_1_69_0
WEBSOCKETPP=${LIB_ROOT}/websocketpp

inc_path+=-I${SSL_ROOT}/include
lib_path+=-L${SSL_ROOT}/lib

inc_path+=-I${ZLIB_ROOT}/include
lib_path+=-L${ZLIB_ROOT}/lib

inc_path+=-I${BOOST_ROOT}/include
lib_path+=-L${BOOST_ROOT}/lib

inc_path+=-I${WEBSOCKETPP}/include
lib_path+=-L${WEBSOCKETPP}/lib

inc_path+=-I${CPPREST_INC}
lib_path+=-L${CPPREST_LIB}

libs+=-lcpprest
libs+=-lboost_atomic
libs+=-lboost_chrono
libs+=-lboost_container
libs+=-lboost_context
libs+=-lboost_contract
libs+=-lboost_coroutine
libs+=-lboost_date_time
libs+=-lboost_exception
libs+=-lboost_filesystem
libs+=-lboost_graph
libs+=-lboost_iostreams
libs+=-lboost_locale
libs+=-lboost_log
libs+=-lboost_log_setup
libs+=-lboost_math_c99
libs+=-lboost_math_c99f
libs+=-lboost_math_c99l
libs+=-lboost_math_tr1
libs+=-lboost_math_tr1f
libs+=-lboost_math_tr1l
#libs+=-lboost_numpy27
libs+=-lboost_prg_exec_monitor
libs+=-lboost_program_options
#libs+=-lboost_python27
libs+=-lboost_random
libs+=-lboost_regex
libs+=-lboost_serialization
libs+=-lboost_stacktrace_addr2line
libs+=-lboost_stacktrace_basic
libs+=-lboost_stacktrace_noop
libs+=-lboost_system
libs+=-lboost_test_exec_monitor
libs+=-lboost_thread
libs+=-lboost_timer
libs+=-lboost_type_erasure
libs+=-lboost_unit_test_framework
libs+=-lboost_wave
libs+=-lboost_wserialization
libs+=-lssl
libs+=-lcrypto
libs+=-lz
libs+=-lpthread
libs+=-ldl

CPPFLAGS=-std=c++11

#SHARED=ON

ifneq ($(SHARED),)
	CPPFLAGS+=-fPIC
	LDFLAGS+=-shared
else
	#sudo yum install libstdc++-static.x86_64 
	LDFLAGS+=-static
endif

all:out $(objs)
		$(CXX) $(LDFLAGS) -o $(exec) $(objs) $(inc_path) $(lib_path) $(libs)

out/$(platform)/%.o:%.cpp
		$(CXX) -o $@ -c $< $(inc_path) $(lib_path) $(CPPFLAGS) $(libs)

out:
		mkdir -p out/$(platform)/src

clean:
	$(RM) $(objs) out -rf


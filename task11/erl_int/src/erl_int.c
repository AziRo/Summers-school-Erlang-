#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include "erl_interface.h"
#include "ei.h"


#define BUF_SIZE 256


int fact(int arg)
{
    int res = 1;

    while (arg > 1) {
        res *= arg--;
    }

    return res;
}


int main(int argc, char const *argv[])
{
    ErlMessage emsg;
    ETERM *fromp, *argp, *resp;
    unsigned char buff[BUF_SIZE];
    int exit = 0;
    erl_init(NULL, 0);
    erl_connect_init(1, "AA", 0);
    int fd = erl_connect("node1@aziro-Aspire-E5-575G");

    while (!exit) {
        int got = erl_receive_msg(fd, buff, BUF_SIZE, &emsg);
        switch (got) {
        case ERL_TICK:
            break;
        case ERL_ERROR:
            exit = 1;
            break;
        default:
            if (emsg.type == ERL_REG_SEND) {
                fromp = erl_element(1, emsg.msg);
                argp = erl_element(2, emsg.msg);
                resp = erl_format("{ok, ~i}", fact(ERL_INT_VALUE(argp)));
                erl_send(fd, fromp, resp);
                erl_free_term(emsg.from);
                erl_free_term(emsg.msg);
                erl_free_term(fromp);
                erl_free_term(argp);
                erl_free_term(resp);
            }
            break;
        }

    }

    return 0;
}

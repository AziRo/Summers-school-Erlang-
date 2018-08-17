#include <erl_nif.h>


int fact(int arg)
{
    int res = 1;

    while (arg > 1) {
        res *= arg--;
    }

    return res;
}


static ERL_NIF_TERM nif_fact(ErlNifEnv* env, int argc,
    const ERL_NIF_TERM argv[])
{
    int x, ret;
    if (!enif_get_int(env, argv[0], &x))
	   return enif_make_badarg(env);
    ret = fact(x);
    return enif_make_int(env, ret);
}


static ErlNifFunc nif_func[] = {
    {"fact", 1, nif_fact},
};


ERL_NIF_INIT(nif, nif_func, NULL, NULL, NULL, NULL)

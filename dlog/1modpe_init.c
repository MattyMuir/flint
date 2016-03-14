/*=============================================================================

    This file is part of ARB.

    ARB is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    ARB is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with ARB; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

=============================================================================*/
/******************************************************************************

    Copyright (C) 2016 Pascal Molin

******************************************************************************/

#include "dlog.h"

void
dlog_1modpe_init(dlog_1modpe_t t, ulong a1, ulong p, ulong e)
{
    fmpz_t tmp;
    t->p = p;
    fmpz_init(tmp);
    padic_init(t->invlog);

    fmpz_set_ui(tmp, p);
    padic_ctx_init(t->ctx , tmp , 0 , e, PADIC_TERSE);

    padic_set_ui(t->invlog, a1, t->ctx);
    padic_inv(t->invlog, t->invlog, t->ctx);

    fmpz_clear(tmp);
}

void
dlog_1modpe_clear(dlog_1modpe_t t)
{
    padic_clear(t->invlog);
    padic_ctx_clear(t->ctx);
}

#
#   Copyright (C) 2023 Albin Ahlbäck
#
#   This file is part of FLINT.
#
#   FLINT is free software: you can redistribute it and/or modify it under
#   the terms of the GNU Lesser General Public License (LGPL) as published
#   by the Free Software Foundation; either version 2.1 of the License, or
#   (at your option) any later version.  See <https://www.gnu.org/licenses/>.
#

include(`config.m4')dnl
dnl
.text

.macro	m3 res=%rdi, res_offset=0, ap=%rsi, ap_offset=0, r0, r1, r2, scr1, scr2, zero
	mulx	(0+\ap_offset)*8(\ap), \scr1, \r0
	mulx	(1+\ap_offset)*8(\ap), \scr2, \r1
	mov	\scr1, \res_offset*8(\res)
	adcx	\scr2, \r0
	mulx	(2+\ap_offset)*8(\ap), \scr1, \r2
	adcx	\scr1, \r1
	adcx	\zero, \r2
.endm

.macro	am3 res=%rdi, res_offset=0, ap=%rsi, ap_offset=0, r0, r1, r2, r3, scr, zero
	mulx	(0+\ap_offset)*8(\ap), \scr, \r3
	adcx	\scr, \r0
	mov	\r0, \res_offset*8(\res)
	mulx	(1+\ap_offset)*8(\ap), \r0, \scr
	adcx	\r3, \r1
	adox	\r0, \r1
	mulx	(2+\ap_offset)*8(\ap), \r0, \r3
	adcx	\scr, \r2
	adox	\r0, \r2
	adcx	\zero, \r3
	adox	\zero, \r3
.endm

.macro	m3_chain res=%rdi, res_offset=0, ap=%rsi, ap_offset=0, ip1, ip2, r0, r1, r2, scr1, scr2, zero
	mulx	(0+\ap_offset)*8(\ap), \scr1, \r0
	adcx	\ip1, \scr1
	mov	\scr1, \res_offset*8(\res)
	mulx	(1+\ap_offset)*8(\ap), \scr2, \r1
	adcx	\scr2, \r0
	adox	\ip2, \r0
	mulx	(2+\ap_offset)*8(\ap), \scr1, \r2
	adcx	\scr1, \r1
	adcx	\zero, \r2
.endm

.global	FUNC(flint_mpn_mul_9_2)
.p2align	4, 0x90
TYPE(flint_mpn_mul_9_2)

FUNC(flint_mpn_mul_9_2):
	.cfi_startproc
	mov	0*8(%rdx), %rcx
	mov	1*8(%rdx), %r8
	push	%rbx
	push	%rbp

	mov	%rcx, %rdx
	xor	%ebp, %ebp
	m3	%rdi, 0, %rsi, 0, %r9, %r10, %r11, %rax, %rbx, %rbp
	mov	%r8, %rdx
	am3	%rdi, 1, %rsi, 0, %r9, %r10, %r11, %rax, %rbx, %rbp
	mov	%r10, 2*8(%rdi)

	mov	%rcx, %rdx
	m3_chain	%rdi, 3, %rsi, 3, %r11, %rax, %r9, %r10, %rax, %rbx, %r11, %rbp
	mov	%r8, %rdx
	am3	%rdi, 4, %rsi, 3, %r9, %r10, %rax, %r11, %rbx, %rbp
	mov	%r10, 5*8(%rdi)

	mov	%rcx, %rdx
	m3_chain	%rdi, 6, %rsi, 6, %rax, %r11, %r9, %r10, %r11, %rbx, %rax, %rbp
	mov	%r8, %rdx
	am3	%rdi, 7, %rsi, 6, %r9, %r10, %r11, %rax, %rbx, %rbp
	mov	%r10, 8*8(%rdi)

	mov	%r11, 9*8(%rdi)
	mov	%rax, 10*8(%rdi)
	pop	%rbp
	pop	%rbx

	ret
.flint_mpn_mul_9_2_end:
SIZE(flint_mpn_mul_9_2, .flint_mpn_mul_9_2_end)
.cfi_endproc

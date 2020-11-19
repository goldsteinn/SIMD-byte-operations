
main:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    $0x8,%rsp
    1008:	48 8b 05 d9 3f 00 00 	mov    0x3fd9(%rip),%rax        # 4fe8 <__gmon_start__>
    100f:	48 85 c0             	test   %rax,%rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	callq  *%rax
    1016:	48 83 c4 08          	add    $0x8,%rsp
    101a:	c3                   	retq   

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 42 3f 00 00    	pushq  0x3f42(%rip)        # 4f68 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 44 3f 00 00    	jmpq   *0x3f44(%rip)        # 4f70 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001030 <strlen@plt>:
    1030:	ff 25 42 3f 00 00    	jmpq   *0x3f42(%rip)        # 4f78 <strlen@GLIBC_2.2.5>
    1036:	68 00 00 00 00       	pushq  $0x0
    103b:	e9 e0 ff ff ff       	jmpq   1020 <.plt>

0000000000001040 <mmap@plt>:
    1040:	ff 25 3a 3f 00 00    	jmpq   *0x3f3a(%rip)        # 4f80 <mmap@GLIBC_2.2.5>
    1046:	68 01 00 00 00       	pushq  $0x1
    104b:	e9 d0 ff ff ff       	jmpq   1020 <.plt>

0000000000001050 <strchr@plt>:
    1050:	ff 25 32 3f 00 00    	jmpq   *0x3f32(%rip)        # 4f88 <strchr@GLIBC_2.2.5>
    1056:	68 02 00 00 00       	pushq  $0x2
    105b:	e9 c0 ff ff ff       	jmpq   1020 <.plt>

0000000000001060 <__assert_fail@plt>:
    1060:	ff 25 2a 3f 00 00    	jmpq   *0x3f2a(%rip)        # 4f90 <__assert_fail@GLIBC_2.2.5>
    1066:	68 03 00 00 00       	pushq  $0x3
    106b:	e9 b0 ff ff ff       	jmpq   1020 <.plt>

0000000000001070 <memset@plt>:
    1070:	ff 25 22 3f 00 00    	jmpq   *0x3f22(%rip)        # 4f98 <memset@GLIBC_2.2.5>
    1076:	68 04 00 00 00       	pushq  $0x4
    107b:	e9 a0 ff ff ff       	jmpq   1020 <.plt>

0000000000001080 <memcmp@plt>:
    1080:	ff 25 1a 3f 00 00    	jmpq   *0x3f1a(%rip)        # 4fa0 <memcmp@GLIBC_2.2.5>
    1086:	68 05 00 00 00       	pushq  $0x5
    108b:	e9 90 ff ff ff       	jmpq   1020 <.plt>

0000000000001090 <strtol@plt>:
    1090:	ff 25 12 3f 00 00    	jmpq   *0x3f12(%rip)        # 4fa8 <strtol@GLIBC_2.2.5>
    1096:	68 06 00 00 00       	pushq  $0x6
    109b:	e9 80 ff ff ff       	jmpq   1020 <.plt>

00000000000010a0 <munmap@plt>:
    10a0:	ff 25 0a 3f 00 00    	jmpq   *0x3f0a(%rip)        # 4fb0 <munmap@GLIBC_2.2.5>
    10a6:	68 07 00 00 00       	pushq  $0x7
    10ab:	e9 70 ff ff ff       	jmpq   1020 <.plt>

00000000000010b0 <mprotect@plt>:
    10b0:	ff 25 02 3f 00 00    	jmpq   *0x3f02(%rip)        # 4fb8 <mprotect@GLIBC_2.2.5>
    10b6:	68 08 00 00 00       	pushq  $0x8
    10bb:	e9 60 ff ff ff       	jmpq   1020 <.plt>

00000000000010c0 <exit@plt>:
    10c0:	ff 25 fa 3e 00 00    	jmpq   *0x3efa(%rip)        # 4fc0 <exit@GLIBC_2.2.5>
    10c6:	68 09 00 00 00       	pushq  $0x9
    10cb:	e9 50 ff ff ff       	jmpq   1020 <.plt>

00000000000010d0 <__fprintf_chk@plt>:
    10d0:	ff 25 f2 3e 00 00    	jmpq   *0x3ef2(%rip)        # 4fc8 <__fprintf_chk@GLIBC_2.3.4>
    10d6:	68 0a 00 00 00       	pushq  $0xa
    10db:	e9 40 ff ff ff       	jmpq   1020 <.plt>

00000000000010e0 <rand@plt>:
    10e0:	ff 25 ea 3e 00 00    	jmpq   *0x3eea(%rip)        # 4fd0 <rand@GLIBC_2.2.5>
    10e6:	68 0b 00 00 00       	pushq  $0xb
    10eb:	e9 30 ff ff ff       	jmpq   1020 <.plt>

Disassembly of section .plt.got:

00000000000010f0 <__cxa_finalize@plt>:
    10f0:	ff 25 02 3f 00 00    	jmpq   *0x3f02(%rip)        # 4ff8 <__cxa_finalize@GLIBC_2.2.5>
    10f6:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000001100 <main>:
    1100:	f3 0f 1e fa          	endbr64 
    1104:	48 83 ec 08          	sub    $0x8,%rsp
    1108:	83 ff 01             	cmp    $0x1,%edi
    110b:	74 10                	je     111d <main+0x1d>
    110d:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
    1111:	ba 0a 00 00 00       	mov    $0xa,%edx
    1116:	31 f6                	xor    %esi,%esi
    1118:	e8 73 ff ff ff       	callq  1090 <strtol@plt>
    111d:	e8 9e 06 00 00       	callq  17c0 <_Z7ctest_Sv>
    1122:	31 c0                	xor    %eax,%eax
    1124:	48 83 c4 08          	add    $0x8,%rsp
    1128:	c3                   	retq   
    1129:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001130 <_start>:
    1130:	f3 0f 1e fa          	endbr64 
    1134:	31 ed                	xor    %ebp,%ebp
    1136:	49 89 d1             	mov    %rdx,%r9
    1139:	5e                   	pop    %rsi
    113a:	48 89 e2             	mov    %rsp,%rdx
    113d:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    1141:	50                   	push   %rax
    1142:	54                   	push   %rsp
    1143:	4c 8d 05 d6 0e 00 00 	lea    0xed6(%rip),%r8        # 2020 <__libc_csu_fini>
    114a:	48 8d 0d 5f 0e 00 00 	lea    0xe5f(%rip),%rcx        # 1fb0 <__libc_csu_init>
    1151:	48 8d 3d a8 ff ff ff 	lea    -0x58(%rip),%rdi        # 1100 <main>
    1158:	ff 15 82 3e 00 00    	callq  *0x3e82(%rip)        # 4fe0 <__libc_start_main@GLIBC_2.2.5>
    115e:	f4                   	hlt    
    115f:	90                   	nop

0000000000001160 <deregister_tm_clones>:
    1160:	48 8d 3d a9 3e 00 00 	lea    0x3ea9(%rip),%rdi        # 5010 <__TMC_END__>
    1167:	48 8d 05 a2 3e 00 00 	lea    0x3ea2(%rip),%rax        # 5010 <__TMC_END__>
    116e:	48 39 f8             	cmp    %rdi,%rax
    1171:	74 15                	je     1188 <deregister_tm_clones+0x28>
    1173:	48 8b 05 5e 3e 00 00 	mov    0x3e5e(%rip),%rax        # 4fd8 <_ITM_deregisterTMCloneTable>
    117a:	48 85 c0             	test   %rax,%rax
    117d:	74 09                	je     1188 <deregister_tm_clones+0x28>
    117f:	ff e0                	jmpq   *%rax
    1181:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1188:	c3                   	retq   
    1189:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001190 <register_tm_clones>:
    1190:	48 8d 3d 79 3e 00 00 	lea    0x3e79(%rip),%rdi        # 5010 <__TMC_END__>
    1197:	48 8d 35 72 3e 00 00 	lea    0x3e72(%rip),%rsi        # 5010 <__TMC_END__>
    119e:	48 29 fe             	sub    %rdi,%rsi
    11a1:	48 89 f0             	mov    %rsi,%rax
    11a4:	48 c1 ee 3f          	shr    $0x3f,%rsi
    11a8:	48 c1 f8 03          	sar    $0x3,%rax
    11ac:	48 01 c6             	add    %rax,%rsi
    11af:	48 d1 fe             	sar    %rsi
    11b2:	74 14                	je     11c8 <register_tm_clones+0x38>
    11b4:	48 8b 05 35 3e 00 00 	mov    0x3e35(%rip),%rax        # 4ff0 <_ITM_registerTMCloneTable>
    11bb:	48 85 c0             	test   %rax,%rax
    11be:	74 08                	je     11c8 <register_tm_clones+0x38>
    11c0:	ff e0                	jmpq   *%rax
    11c2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    11c8:	c3                   	retq   
    11c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000011d0 <__do_global_dtors_aux>:
    11d0:	f3 0f 1e fa          	endbr64 
    11d4:	80 3d 4d 3e 00 00 00 	cmpb   $0x0,0x3e4d(%rip)        # 5028 <completed.8060>
    11db:	75 2b                	jne    1208 <__do_global_dtors_aux+0x38>
    11dd:	55                   	push   %rbp
    11de:	48 83 3d 12 3e 00 00 	cmpq   $0x0,0x3e12(%rip)        # 4ff8 <__cxa_finalize@GLIBC_2.2.5>
    11e5:	00 
    11e6:	48 89 e5             	mov    %rsp,%rbp
    11e9:	74 0c                	je     11f7 <__do_global_dtors_aux+0x27>
    11eb:	48 8b 3d 16 3e 00 00 	mov    0x3e16(%rip),%rdi        # 5008 <__dso_handle>
    11f2:	e8 f9 fe ff ff       	callq  10f0 <__cxa_finalize@plt>
    11f7:	e8 64 ff ff ff       	callq  1160 <deregister_tm_clones>
    11fc:	c6 05 25 3e 00 00 01 	movb   $0x1,0x3e25(%rip)        # 5028 <completed.8060>
    1203:	5d                   	pop    %rbp
    1204:	c3                   	retq   
    1205:	0f 1f 00             	nopl   (%rax)
    1208:	c3                   	retq   
    1209:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001210 <frame_dummy>:
    1210:	f3 0f 1e fa          	endbr64 
    1214:	e9 77 ff ff ff       	jmpq   1190 <register_tm_clones>
    1219:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001220 <_Z14strlen_wrapperPc>:
    1220:	f3 0f 1e fa          	endbr64 
    1224:	53                   	push   %rbx
    1225:	48 89 fb             	mov    %rdi,%rbx
    1228:	e8 53 08 00 00       	callq  1a80 <strlen_avx2>
    122d:	48 29 d8             	sub    %rbx,%rax
    1230:	5b                   	pop    %rbx
    1231:	c3                   	retq   
    1232:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    1239:	00 00 00 00 
    123d:	0f 1f 00             	nopl   (%rax)

0000000000001240 <_Z8rand_strPcj>:
    1240:	f3 0f 1e fa          	endbr64 
    1244:	41 55                	push   %r13
    1246:	41 54                	push   %r12
    1248:	49 89 fc             	mov    %rdi,%r12
    124b:	55                   	push   %rbp
    124c:	89 f5                	mov    %esi,%ebp
    124e:	53                   	push   %rbx
    124f:	48 83 ec 08          	sub    $0x8,%rsp
    1253:	85 ed                	test   %ebp,%ebp
    1255:	74 3f                	je     1296 <_Z8rand_strPcj+0x56>
    1257:	8d 45 ff             	lea    -0x1(%rbp),%eax
    125a:	49 89 fd             	mov    %rdi,%r13
    125d:	48 8d 5c 07 01       	lea    0x1(%rdi,%rax,1),%rbx
    1262:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1268:	e8 73 fe ff ff       	callq  10e0 <rand@plt>
    126d:	48 63 d0             	movslq %eax,%rdx
    1270:	48 69 d2 4f ec c4 4e 	imul   $0x4ec4ec4f,%rdx,%rdx
    1277:	89 c1                	mov    %eax,%ecx
    1279:	c1 f9 1f             	sar    $0x1f,%ecx
    127c:	48 c1 fa 23          	sar    $0x23,%rdx
    1280:	29 ca                	sub    %ecx,%edx
    1282:	6b d2 1a             	imul   $0x1a,%edx,%edx
    1285:	49 ff c5             	inc    %r13
    1288:	29 d0                	sub    %edx,%eax
    128a:	83 c0 41             	add    $0x41,%eax
    128d:	41 88 45 ff          	mov    %al,-0x1(%r13)
    1291:	49 39 dd             	cmp    %rbx,%r13
    1294:	75 d2                	jne    1268 <_Z8rand_strPcj+0x28>
    1296:	41 c6 04 2c 00       	movb   $0x0,(%r12,%rbp,1)
    129b:	48 83 c4 08          	add    $0x8,%rsp
    129f:	5b                   	pop    %rbx
    12a0:	5d                   	pop    %rbp
    12a1:	41 5c                	pop    %r12
    12a3:	41 5d                	pop    %r13
    12a5:	c3                   	retq   
    12a6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    12ad:	00 00 00 

00000000000012b0 <_Z11strcpy_testv>:
    12b0:	f3 0f 1e fa          	endbr64 
    12b4:	41 57                	push   %r15
    12b6:	45 31 c9             	xor    %r9d,%r9d
    12b9:	31 ff                	xor    %edi,%edi
    12bb:	41 56                	push   %r14
    12bd:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
    12c3:	b9 22 00 00 00       	mov    $0x22,%ecx
    12c8:	41 55                	push   %r13
    12ca:	ba 03 00 00 00       	mov    $0x3,%edx
    12cf:	be 00 30 00 00       	mov    $0x3000,%esi
    12d4:	41 54                	push   %r12
    12d6:	55                   	push   %rbp
    12d7:	53                   	push   %rbx
    12d8:	48 83 ec 58          	sub    $0x58,%rsp
    12dc:	e8 5f fd ff ff       	callq  1040 <mmap@plt>
    12e1:	48 89 c3             	mov    %rax,%rbx
    12e4:	31 ff                	xor    %edi,%edi
    12e6:	45 31 c9             	xor    %r9d,%r9d
    12e9:	ba 03 00 00 00       	mov    $0x3,%edx
    12ee:	be 00 30 00 00       	mov    $0x3000,%esi
    12f3:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
    12f9:	b9 22 00 00 00       	mov    $0x22,%ecx
    12fe:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
    1303:	e8 38 fd ff ff       	callq  1040 <mmap@plt>
    1308:	31 d2                	xor    %edx,%edx
    130a:	48 8d bb 00 20 00 00 	lea    0x2000(%rbx),%rdi
    1311:	be 00 10 00 00       	mov    $0x1000,%esi
    1316:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
    131b:	e8 90 fd ff ff       	callq  10b0 <mprotect@plt>
    1320:	85 c0                	test   %eax,%eax
    1322:	0f 85 6b 04 00 00    	jne    1793 <_Z11strcpy_testv+0x4e3>
    1328:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
    132d:	31 d2                	xor    %edx,%edx
    132f:	48 8d b8 00 20 00 00 	lea    0x2000(%rax),%rdi
    1336:	be 00 10 00 00       	mov    $0x1000,%esi
    133b:	e8 70 fd ff ff       	callq  10b0 <mprotect@plt>
    1340:	85 c0                	test   %eax,%eax
    1342:	0f 85 2c 04 00 00    	jne    1774 <_Z11strcpy_testv+0x4c4>
    1348:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
    134d:	ba 00 20 00 00       	mov    $0x2000,%edx
    1352:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1357:	e8 14 fd ff ff       	callq  1070 <memset@plt>
    135c:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
    1361:	ba 00 20 00 00       	mov    $0x2000,%edx
    1366:	be ff ff ff ff       	mov    $0xffffffff,%esi
    136b:	e8 00 fd ff ff       	callq  1070 <memset@plt>
    1370:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
    1377:	00 
    1378:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%rsp)
    137f:	00 
    1380:	8b 5c 24 44          	mov    0x44(%rsp),%ebx
    1384:	83 fb 7f             	cmp    $0x7f,%ebx
    1387:	0f 87 27 02 00 00    	ja     15b4 <_Z11strcpy_testv+0x304>
    138d:	44 8b 74 24 40       	mov    0x40(%rsp),%r14d
    1392:	89 d8                	mov    %ebx,%eax
    1394:	44 29 f0             	sub    %r14d,%eax
    1397:	48 8b 3d 82 3c 00 00 	mov    0x3c82(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    139e:	89 44 24 30          	mov    %eax,0x30(%rsp)
    13a2:	89 c1                	mov    %eax,%ecx
    13a4:	48 8d 15 74 1c 00 00 	lea    0x1c74(%rip),%rdx        # 301f <_IO_stdin_used+0x1f>
    13ab:	31 c0                	xor    %eax,%eax
    13ad:	be 01 00 00 00       	mov    $0x1,%esi
    13b2:	e8 19 fd ff ff       	callq  10d0 <__fprintf_chk@plt>
    13b7:	41 8d 86 00 20 00 00 	lea    0x2000(%r14),%eax
    13be:	29 d8                	sub    %ebx,%eax
    13c0:	89 44 24 34          	mov    %eax,0x34(%rsp)
    13c4:	0f 84 d9 01 00 00    	je     15a3 <_Z11strcpy_testv+0x2f3>
    13ca:	8b 44 24 30          	mov    0x30(%rsp),%eax
    13ce:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
    13d3:	45 31 f6             	xor    %r14d,%r14d
    13d6:	48 8d 2c 06          	lea    (%rsi,%rax,1),%rbp
    13da:	48 03 44 24 28       	add    0x28(%rsp),%rax
    13df:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    13e4:	48 8d 45 01          	lea    0x1(%rbp),%rax
    13e8:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
    13ed:	0f 1f 00             	nopl   (%rax)
    13f0:	8b 44 24 30          	mov    0x30(%rsp),%eax
    13f4:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
    13f9:	41 8d 1c 06          	lea    (%r14,%rax,1),%ebx
    13fd:	41 8d 46 ff          	lea    -0x1(%r14),%eax
    1401:	48 ff c0             	inc    %rax
    1404:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    1409:	89 1c 24             	mov    %ebx,(%rsp)
    140c:	45 31 e4             	xor    %r12d,%r12d
    140f:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
    1414:	44 89 74 24 0c       	mov    %r14d,0xc(%rsp)
    1419:	45 89 e7             	mov    %r12d,%r15d
    141c:	49 89 ee             	mov    %rbp,%r14
    141f:	90                   	nop
    1420:	8b 04 24             	mov    (%rsp),%eax
    1423:	44 01 f8             	add    %r15d,%eax
    1426:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
    142b:	77 76                	ja     14a3 <_Z11strcpy_testv+0x1f3>
    142d:	44 8b 64 24 0c       	mov    0xc(%rsp),%r12d
    1432:	45 85 e4             	test   %r12d,%r12d
    1435:	0f 84 c5 01 00 00    	je     1600 <_Z11strcpy_testv+0x350>
    143b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    1440:	4c 89 f3             	mov    %r14,%rbx
    1443:	4a 8d 2c 30          	lea    (%rax,%r14,1),%rbp
    1447:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    144e:	00 00 
    1450:	e8 8b fc ff ff       	callq  10e0 <rand@plt>
    1455:	48 63 d0             	movslq %eax,%rdx
    1458:	48 69 d2 4f ec c4 4e 	imul   $0x4ec4ec4f,%rdx,%rdx
    145f:	89 c1                	mov    %eax,%ecx
    1461:	c1 f9 1f             	sar    $0x1f,%ecx
    1464:	48 c1 fa 23          	sar    $0x23,%rdx
    1468:	29 ca                	sub    %ecx,%edx
    146a:	6b d2 1a             	imul   $0x1a,%edx,%edx
    146d:	48 ff c3             	inc    %rbx
    1470:	29 d0                	sub    %edx,%eax
    1472:	83 c0 41             	add    $0x41,%eax
    1475:	88 43 ff             	mov    %al,-0x1(%rbx)
    1478:	48 39 eb             	cmp    %rbp,%rbx
    147b:	75 d3                	jne    1450 <_Z11strcpy_testv+0x1a0>
    147d:	43 c6 04 26 00       	movb   $0x0,(%r14,%r12,1)
    1482:	4c 89 f6             	mov    %r14,%rsi
    1485:	4c 89 ef             	mov    %r13,%rdi
    1488:	e8 c3 08 00 00       	callq  1d50 <strcpy_avx2>
    148d:	4c 89 e2             	mov    %r12,%rdx
    1490:	4c 89 ee             	mov    %r13,%rsi
    1493:	4c 89 f7             	mov    %r14,%rdi
    1496:	e8 e5 fb ff ff       	callq  1080 <memcmp@plt>
    149b:	85 c0                	test   %eax,%eax
    149d:	0f 85 8f 01 00 00    	jne    1632 <_Z11strcpy_testv+0x382>
    14a3:	41 ff c7             	inc    %r15d
    14a6:	49 ff c6             	inc    %r14
    14a9:	41 83 ff 20          	cmp    $0x20,%r15d
    14ad:	0f 85 6d ff ff ff    	jne    1420 <_Z11strcpy_testv+0x170>
    14b3:	44 8b 74 24 0c       	mov    0xc(%rsp),%r14d
    14b8:	8b 1c 24             	mov    (%rsp),%ebx
    14bb:	41 8d 46 ff          	lea    -0x1(%r14),%eax
    14bf:	48 03 44 24 38       	add    0x38(%rsp),%rax
    14c4:	48 89 04 24          	mov    %rax,(%rsp)
    14c8:	45 31 e4             	xor    %r12d,%r12d
    14cb:	48 8b 6c 24 20       	mov    0x20(%rsp),%rbp
    14d0:	4d 89 e7             	mov    %r12,%r15
    14d3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    14d8:	42 8d 04 3b          	lea    (%rbx,%r15,1),%eax
    14dc:	44 89 7c 24 0c       	mov    %r15d,0xc(%rsp)
    14e1:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
    14e6:	0f 87 7e 00 00 00    	ja     156a <_Z11strcpy_testv+0x2ba>
    14ec:	45 89 f5             	mov    %r14d,%r13d
    14ef:	4a 8d 44 2d 00       	lea    0x0(%rbp,%r13,1),%rax
    14f4:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    14f9:	45 85 f6             	test   %r14d,%r14d
    14fc:	0f 84 16 01 00 00    	je     1618 <_Z11strcpy_testv+0x368>
    1502:	49 89 ec             	mov    %rbp,%r12
    1505:	0f 1f 00             	nopl   (%rax)
    1508:	e8 d3 fb ff ff       	callq  10e0 <rand@plt>
    150d:	48 63 d0             	movslq %eax,%rdx
    1510:	48 69 d2 4f ec c4 4e 	imul   $0x4ec4ec4f,%rdx,%rdx
    1517:	89 c1                	mov    %eax,%ecx
    1519:	c1 f9 1f             	sar    $0x1f,%ecx
    151c:	48 c1 fa 23          	sar    $0x23,%rdx
    1520:	29 ca                	sub    %ecx,%edx
    1522:	6b d2 1a             	imul   $0x1a,%edx,%edx
    1525:	49 ff c4             	inc    %r12
    1528:	29 d0                	sub    %edx,%eax
    152a:	83 c0 41             	add    $0x41,%eax
    152d:	41 88 44 24 ff       	mov    %al,-0x1(%r12)
    1532:	4c 39 24 24          	cmp    %r12,(%rsp)
    1536:	75 d0                	jne    1508 <_Z11strcpy_testv+0x258>
    1538:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    153d:	48 89 ee             	mov    %rbp,%rsi
    1540:	c6 00 00             	movb   $0x0,(%rax)
    1543:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    1548:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
    154c:	4c 89 e7             	mov    %r12,%rdi
    154f:	e8 fc 07 00 00       	callq  1d50 <strcpy_avx2>
    1554:	4c 89 ea             	mov    %r13,%rdx
    1557:	4c 89 e6             	mov    %r12,%rsi
    155a:	48 89 ef             	mov    %rbp,%rdi
    155d:	e8 1e fb ff ff       	callq  1080 <memcmp@plt>
    1562:	85 c0                	test   %eax,%eax
    1564:	0f 85 81 01 00 00    	jne    16eb <_Z11strcpy_testv+0x43b>
    156a:	49 ff c7             	inc    %r15
    156d:	49 83 ff 20          	cmp    $0x20,%r15
    1571:	0f 85 61 ff ff ff    	jne    14d8 <_Z11strcpy_testv+0x228>
    1577:	e8 64 fb ff ff       	callq  10e0 <rand@plt>
    157c:	99                   	cltd   
    157d:	c1 ea 1b             	shr    $0x1b,%edx
    1580:	01 d0                	add    %edx,%eax
    1582:	83 e0 1f             	and    $0x1f,%eax
    1585:	29 d0                	sub    %edx,%eax
    1587:	41 01 c6             	add    %eax,%r14d
    158a:	44 3b 74 24 34       	cmp    0x34(%rsp),%r14d
    158f:	0f 82 5b fe ff ff    	jb     13f0 <_Z11strcpy_testv+0x140>
    1595:	81 7c 24 44 ff 00 00 	cmpl   $0xff,0x44(%rsp)
    159c:	00 
    159d:	0f 84 fc 00 00 00    	je     169f <_Z11strcpy_testv+0x3ef>
    15a3:	ff 44 24 44          	incl   0x44(%rsp)
    15a7:	8b 5c 24 44          	mov    0x44(%rsp),%ebx
    15ab:	83 fb 7f             	cmp    $0x7f,%ebx
    15ae:	0f 86 d9 fd ff ff    	jbe    138d <_Z11strcpy_testv+0xdd>
    15b4:	44 8b 74 24 40       	mov    0x40(%rsp),%r14d
    15b9:	b8 00 10 00 00       	mov    $0x1000,%eax
    15be:	83 e3 7f             	and    $0x7f,%ebx
    15c1:	44 29 f0             	sub    %r14d,%eax
    15c4:	29 d8                	sub    %ebx,%eax
    15c6:	48 8b 3d 53 3a 00 00 	mov    0x3a53(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    15cd:	89 44 24 30          	mov    %eax,0x30(%rsp)
    15d1:	89 c1                	mov    %eax,%ecx
    15d3:	48 8d 15 45 1a 00 00 	lea    0x1a45(%rip),%rdx        # 301f <_IO_stdin_used+0x1f>
    15da:	be 01 00 00 00       	mov    $0x1,%esi
    15df:	31 c0                	xor    %eax,%eax
    15e1:	e8 ea fa ff ff       	callq  10d0 <__fprintf_chk@plt>
    15e6:	42 8d 84 33 00 10 00 	lea    0x1000(%rbx,%r14,1),%eax
    15ed:	00 
    15ee:	89 44 24 34          	mov    %eax,0x34(%rsp)
    15f2:	85 c0                	test   %eax,%eax
    15f4:	0f 85 d0 fd ff ff    	jne    13ca <_Z11strcpy_testv+0x11a>
    15fa:	eb 99                	jmp    1595 <_Z11strcpy_testv+0x2e5>
    15fc:	0f 1f 40 00          	nopl   0x0(%rax)
    1600:	41 c6 06 00          	movb   $0x0,(%r14)
    1604:	4c 89 f6             	mov    %r14,%rsi
    1607:	4c 89 ef             	mov    %r13,%rdi
    160a:	e8 41 07 00 00       	callq  1d50 <strcpy_avx2>
    160f:	e9 8f fe ff ff       	jmpq   14a3 <_Z11strcpy_testv+0x1f3>
    1614:	0f 1f 40 00          	nopl   0x0(%rax)
    1618:	89 df                	mov    %ebx,%edi
    161a:	c6 00 00             	movb   $0x0,(%rax)
    161d:	48 03 7c 24 28       	add    0x28(%rsp),%rdi
    1622:	4c 01 ff             	add    %r15,%rdi
    1625:	48 89 ee             	mov    %rbp,%rsi
    1628:	e8 23 07 00 00       	callq  1d50 <strcpy_avx2>
    162d:	e9 38 ff ff ff       	jmpq   156a <_Z11strcpy_testv+0x2ba>
    1632:	44 8b 44 24 0c       	mov    0xc(%rsp),%r8d
    1637:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
    163b:	48 8b 3d de 39 00 00 	mov    0x39de(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    1642:	44 89 fd             	mov    %r15d,%ebp
    1645:	41 89 e9             	mov    %ebp,%r9d
    1648:	48 8d 15 d4 19 00 00 	lea    0x19d4(%rip),%rdx        # 3023 <_IO_stdin_used+0x23>
    164f:	be 01 00 00 00       	mov    $0x1,%esi
    1654:	31 c0                	xor    %eax,%eax
    1656:	e8 75 fa ff ff       	callq  10d0 <__fprintf_chk@plt>
    165b:	48 8b 3d be 39 00 00 	mov    0x39be(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    1662:	4c 89 f1             	mov    %r14,%rcx
    1665:	48 8d 15 c8 19 00 00 	lea    0x19c8(%rip),%rdx        # 3034 <_IO_stdin_used+0x34>
    166c:	be 01 00 00 00       	mov    $0x1,%esi
    1671:	31 c0                	xor    %eax,%eax
    1673:	e8 58 fa ff ff       	callq  10d0 <__fprintf_chk@plt>
    1678:	4c 89 e9             	mov    %r13,%rcx
    167b:	48 8b 3d 9e 39 00 00 	mov    0x399e(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    1682:	48 8d 15 b5 19 00 00 	lea    0x19b5(%rip),%rdx        # 303e <_IO_stdin_used+0x3e>
    1689:	be 01 00 00 00       	mov    $0x1,%esi
    168e:	31 c0                	xor    %eax,%eax
    1690:	e8 3b fa ff ff       	callq  10d0 <__fprintf_chk@plt>
    1695:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    169a:	e8 21 fa ff ff       	callq  10c0 <exit@plt>
    169f:	81 6c 24 40 00 10 00 	subl   $0x1000,0x40(%rsp)
    16a6:	00 
    16a7:	8b 44 24 40          	mov    0x40(%rsp),%eax
    16ab:	3d 00 e0 ff ff       	cmp    $0xffffe000,%eax
    16b0:	0f 85 c2 fc ff ff    	jne    1378 <_Z11strcpy_testv+0xc8>
    16b6:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
    16bb:	be 00 30 00 00       	mov    $0x3000,%esi
    16c0:	e8 db f9 ff ff       	callq  10a0 <munmap@plt>
    16c5:	85 c0                	test   %eax,%eax
    16c7:	75 6d                	jne    1736 <_Z11strcpy_testv+0x486>
    16c9:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
    16ce:	be 00 30 00 00       	mov    $0x3000,%esi
    16d3:	e8 c8 f9 ff ff       	callq  10a0 <munmap@plt>
    16d8:	85 c0                	test   %eax,%eax
    16da:	75 79                	jne    1755 <_Z11strcpy_testv+0x4a5>
    16dc:	48 83 c4 58          	add    $0x58,%rsp
    16e0:	5b                   	pop    %rbx
    16e1:	5d                   	pop    %rbp
    16e2:	41 5c                	pop    %r12
    16e4:	41 5d                	pop    %r13
    16e6:	41 5e                	pop    %r14
    16e8:	41 5f                	pop    %r15
    16ea:	c3                   	retq   
    16eb:	44 8b 4c 24 0c       	mov    0xc(%rsp),%r9d
    16f0:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
    16f4:	48 8b 3d 25 39 00 00 	mov    0x3925(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    16fb:	45 89 f0             	mov    %r14d,%r8d
    16fe:	48 8d 15 43 19 00 00 	lea    0x1943(%rip),%rdx        # 3048 <_IO_stdin_used+0x48>
    1705:	be 01 00 00 00       	mov    $0x1,%esi
    170a:	31 c0                	xor    %eax,%eax
    170c:	e8 bf f9 ff ff       	callq  10d0 <__fprintf_chk@plt>
    1711:	48 8b 3d 08 39 00 00 	mov    0x3908(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    1718:	48 89 e9             	mov    %rbp,%rcx
    171b:	48 8d 15 12 19 00 00 	lea    0x1912(%rip),%rdx        # 3034 <_IO_stdin_used+0x34>
    1722:	be 01 00 00 00       	mov    $0x1,%esi
    1727:	31 c0                	xor    %eax,%eax
    1729:	e8 a2 f9 ff ff       	callq  10d0 <__fprintf_chk@plt>
    172e:	4c 89 e1             	mov    %r12,%rcx
    1731:	e9 45 ff ff ff       	jmpq   167b <_Z11strcpy_testv+0x3cb>
    1736:	48 8d 0d c7 18 00 00 	lea    0x18c7(%rip),%rcx        # 3004 <_IO_stdin_used+0x4>
    173d:	ba 54 00 00 00       	mov    $0x54,%edx
    1742:	48 8d 35 ce 18 00 00 	lea    0x18ce(%rip),%rsi        # 3017 <_IO_stdin_used+0x17>
    1749:	48 8d 3d 09 19 00 00 	lea    0x1909(%rip),%rdi        # 3059 <_IO_stdin_used+0x59>
    1750:	e8 0b f9 ff ff       	callq  1060 <__assert_fail@plt>
    1755:	48 8d 0d a8 18 00 00 	lea    0x18a8(%rip),%rcx        # 3004 <_IO_stdin_used+0x4>
    175c:	ba 55 00 00 00       	mov    $0x55,%edx
    1761:	48 8d 35 af 18 00 00 	lea    0x18af(%rip),%rsi        # 3017 <_IO_stdin_used+0x17>
    1768:	48 8d 3d 02 19 00 00 	lea    0x1902(%rip),%rdi        # 3071 <_IO_stdin_used+0x71>
    176f:	e8 ec f8 ff ff       	callq  1060 <__assert_fail@plt>
    1774:	48 8d 0d 89 18 00 00 	lea    0x1889(%rip),%rcx        # 3004 <_IO_stdin_used+0x4>
    177b:	ba 2d 00 00 00       	mov    $0x2d,%edx
    1780:	48 8d 35 90 18 00 00 	lea    0x1890(%rip),%rsi        # 3017 <_IO_stdin_used+0x17>
    1787:	48 8d 3d 6a 19 00 00 	lea    0x196a(%rip),%rdi        # 30f8 <_IO_stdin_used+0xf8>
    178e:	e8 cd f8 ff ff       	callq  1060 <__assert_fail@plt>
    1793:	48 8d 0d 6a 18 00 00 	lea    0x186a(%rip),%rcx        # 3004 <_IO_stdin_used+0x4>
    179a:	ba 2c 00 00 00       	mov    $0x2c,%edx
    179f:	48 8d 35 71 18 00 00 	lea    0x1871(%rip),%rsi        # 3017 <_IO_stdin_used+0x17>
    17a6:	48 8d 3d 23 19 00 00 	lea    0x1923(%rip),%rdi        # 30d0 <_IO_stdin_used+0xd0>
    17ad:	e8 ae f8 ff ff       	callq  1060 <__assert_fail@plt>
    17b2:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    17b9:	00 00 00 00 
    17bd:	0f 1f 00             	nopl   (%rax)

00000000000017c0 <_Z7ctest_Sv>:
    17c0:	f3 0f 1e fa          	endbr64 
    17c4:	41 57                	push   %r15
    17c6:	45 31 c9             	xor    %r9d,%r9d
    17c9:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
    17cf:	41 56                	push   %r14
    17d1:	b9 22 00 00 00       	mov    $0x22,%ecx
    17d6:	ba 03 00 00 00       	mov    $0x3,%edx
    17db:	41 55                	push   %r13
    17dd:	be 00 30 00 00       	mov    $0x3000,%esi
    17e2:	31 ff                	xor    %edi,%edi
    17e4:	41 54                	push   %r12
    17e6:	55                   	push   %rbp
    17e7:	53                   	push   %rbx
    17e8:	48 83 ec 28          	sub    $0x28,%rsp
    17ec:	e8 4f f8 ff ff       	callq  1040 <mmap@plt>
    17f1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    17f6:	48 85 c0             	test   %rax,%rax
    17f9:	0f 84 19 02 00 00    	je     1a18 <_Z7ctest_Sv+0x258>
    17ff:	31 d2                	xor    %edx,%edx
    1801:	48 8d b8 00 20 00 00 	lea    0x2000(%rax),%rdi
    1808:	be 00 10 00 00       	mov    $0x1000,%esi
    180d:	e8 9e f8 ff ff       	callq  10b0 <mprotect@plt>
    1812:	85 c0                	test   %eax,%eax
    1814:	0f 85 3c 02 00 00    	jne    1a56 <_Z7ctest_Sv+0x296>
    181a:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
    181f:	ba 00 20 00 00       	mov    $0x2000,%edx
    1824:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1829:	48 89 df             	mov    %rbx,%rdi
    182c:	e8 3f f8 ff ff       	callq  1070 <memset@plt>
    1831:	c6 83 ff 1f 00 00 00 	movb   $0x0,0x1fff(%rbx)
    1838:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%rsp)
    183f:	00 
    1840:	48 89 dd             	mov    %rbx,%rbp
    1843:	4c 8d 3d 5b 18 00 00 	lea    0x185b(%rip),%r15        # 30a5 <_IO_stdin_used+0xa5>
    184a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1850:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
    1854:	31 db                	xor    %ebx,%ebx
    1856:	8d 50 ff             	lea    -0x1(%rax),%edx
    1859:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
    185e:	85 c0                	test   %eax,%eax
    1860:	0f 85 93 00 00 00    	jne    18f9 <_Z7ctest_Sv+0x139>
    1866:	e9 7f 01 00 00       	jmpq   19ea <_Z7ctest_Sv+0x22a>
    186b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1870:	44 8d 63 ff          	lea    -0x1(%rbx),%r12d
    1874:	4c 03 64 24 08       	add    0x8(%rsp),%r12
    1879:	41 c6 04 24 01       	movb   $0x1,(%r12)
    187e:	be 01 00 00 00       	mov    $0x1,%esi
    1883:	4c 89 f7             	mov    %r14,%rdi
    1886:	e8 c5 f7 ff ff       	callq  1050 <strchr@plt>
    188b:	be 01 00 00 00       	mov    $0x1,%esi
    1890:	4c 89 f7             	mov    %r14,%rdi
    1893:	49 89 c5             	mov    %rax,%r13
    1896:	e8 15 03 00 00       	callq  1bb0 <strchr_avx2>
    189b:	49 39 c5             	cmp    %rax,%r13
    189e:	74 3e                	je     18de <_Z7ctest_Sv+0x11e>
    18a0:	be 01 00 00 00       	mov    $0x1,%esi
    18a5:	4c 89 f7             	mov    %r14,%rdi
    18a8:	e8 03 03 00 00       	callq  1bb0 <strchr_avx2>
    18ad:	be 01 00 00 00       	mov    $0x1,%esi
    18b2:	4c 89 f7             	mov    %r14,%rdi
    18b5:	49 89 c5             	mov    %rax,%r13
    18b8:	e8 93 f7 ff ff       	callq  1050 <strchr@plt>
    18bd:	48 8b 3d 5c 37 00 00 	mov    0x375c(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    18c4:	49 89 c0             	mov    %rax,%r8
    18c7:	4d 89 e9             	mov    %r13,%r9
    18ca:	b9 80 00 00 00       	mov    $0x80,%ecx
    18cf:	4c 89 fa             	mov    %r15,%rdx
    18d2:	be 01 00 00 00       	mov    $0x1,%esi
    18d7:	31 c0                	xor    %eax,%eax
    18d9:	e8 f2 f7 ff ff       	callq  10d0 <__fprintf_chk@plt>
    18de:	41 c6 04 24 ff       	movb   $0xff,(%r12)
    18e3:	c6 45 00 ff          	movb   $0xff,0x0(%rbp)
    18e7:	48 8d 43 01          	lea    0x1(%rbx),%rax
    18eb:	48 39 5c 24 10       	cmp    %rbx,0x10(%rsp)
    18f0:	0f 84 ea 00 00 00    	je     19e0 <_Z7ctest_Sv+0x220>
    18f6:	48 89 c3             	mov    %rax,%rbx
    18f9:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    18fe:	c6 45 00 00          	movb   $0x0,0x0(%rbp)
    1902:	4c 8d 34 18          	lea    (%rax,%rbx,1),%r14
    1906:	4c 89 f7             	mov    %r14,%rdi
    1909:	e8 22 f7 ff ff       	callq  1030 <strlen@plt>
    190e:	4c 89 f7             	mov    %r14,%rdi
    1911:	49 89 c4             	mov    %rax,%r12
    1914:	e8 67 01 00 00       	callq  1a80 <strlen_avx2>
    1919:	4c 29 f0             	sub    %r14,%rax
    191c:	49 39 c4             	cmp    %rax,%r12
    191f:	74 37                	je     1958 <_Z7ctest_Sv+0x198>
    1921:	4c 89 f7             	mov    %r14,%rdi
    1924:	e8 57 01 00 00       	callq  1a80 <strlen_avx2>
    1929:	49 89 c4             	mov    %rax,%r12
    192c:	4c 89 f7             	mov    %r14,%rdi
    192f:	e8 fc f6 ff ff       	callq  1030 <strlen@plt>
    1934:	4d 89 e1             	mov    %r12,%r9
    1937:	48 8b 3d e2 36 00 00 	mov    0x36e2(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    193e:	49 89 c0             	mov    %rax,%r8
    1941:	4d 29 f1             	sub    %r14,%r9
    1944:	b9 7a 00 00 00       	mov    $0x7a,%ecx
    1949:	4c 89 fa             	mov    %r15,%rdx
    194c:	be 01 00 00 00       	mov    $0x1,%esi
    1951:	31 c0                	xor    %eax,%eax
    1953:	e8 78 f7 ff ff       	callq  10d0 <__fprintf_chk@plt>
    1958:	c6 45 00 01          	movb   $0x1,0x0(%rbp)
    195c:	48 85 db             	test   %rbx,%rbx
    195f:	0f 85 0b ff ff ff    	jne    1870 <_Z7ctest_Sv+0xb0>
    1965:	be 01 00 00 00       	mov    $0x1,%esi
    196a:	4c 89 f7             	mov    %r14,%rdi
    196d:	e8 de f6 ff ff       	callq  1050 <strchr@plt>
    1972:	be 01 00 00 00       	mov    $0x1,%esi
    1977:	4c 89 f7             	mov    %r14,%rdi
    197a:	49 89 c4             	mov    %rax,%r12
    197d:	e8 2e 02 00 00       	callq  1bb0 <strchr_avx2>
    1982:	49 39 c4             	cmp    %rax,%r12
    1985:	0f 84 58 ff ff ff    	je     18e3 <_Z7ctest_Sv+0x123>
    198b:	be 01 00 00 00       	mov    $0x1,%esi
    1990:	4c 89 f7             	mov    %r14,%rdi
    1993:	e8 18 02 00 00       	callq  1bb0 <strchr_avx2>
    1998:	be 01 00 00 00       	mov    $0x1,%esi
    199d:	4c 89 f7             	mov    %r14,%rdi
    19a0:	49 89 c4             	mov    %rax,%r12
    19a3:	e8 a8 f6 ff ff       	callq  1050 <strchr@plt>
    19a8:	48 8b 3d 71 36 00 00 	mov    0x3671(%rip),%rdi        # 5020 <stderr@@GLIBC_2.2.5>
    19af:	49 89 c0             	mov    %rax,%r8
    19b2:	4d 89 e1             	mov    %r12,%r9
    19b5:	b9 80 00 00 00       	mov    $0x80,%ecx
    19ba:	4c 89 fa             	mov    %r15,%rdx
    19bd:	be 01 00 00 00       	mov    $0x1,%esi
    19c2:	31 c0                	xor    %eax,%eax
    19c4:	e8 07 f7 ff ff       	callq  10d0 <__fprintf_chk@plt>
    19c9:	c6 45 00 ff          	movb   $0xff,0x0(%rbp)
    19cd:	48 8d 43 01          	lea    0x1(%rbx),%rax
    19d1:	48 39 5c 24 10       	cmp    %rbx,0x10(%rsp)
    19d6:	0f 85 1a ff ff ff    	jne    18f6 <_Z7ctest_Sv+0x136>
    19dc:	0f 1f 40 00          	nopl   0x0(%rax)
    19e0:	81 7c 24 1c ff 1f 00 	cmpl   $0x1fff,0x1c(%rsp)
    19e7:	00 
    19e8:	74 0c                	je     19f6 <_Z7ctest_Sv+0x236>
    19ea:	ff 44 24 1c          	incl   0x1c(%rsp)
    19ee:	48 ff c5             	inc    %rbp
    19f1:	e9 5a fe ff ff       	jmpq   1850 <_Z7ctest_Sv+0x90>
    19f6:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
    19fb:	be 00 30 00 00       	mov    $0x3000,%esi
    1a00:	e8 9b f6 ff ff       	callq  10a0 <munmap@plt>
    1a05:	85 c0                	test   %eax,%eax
    1a07:	75 2e                	jne    1a37 <_Z7ctest_Sv+0x277>
    1a09:	48 83 c4 28          	add    $0x28,%rsp
    1a0d:	5b                   	pop    %rbx
    1a0e:	5d                   	pop    %rbp
    1a0f:	41 5c                	pop    %r12
    1a11:	41 5d                	pop    %r13
    1a13:	41 5e                	pop    %r14
    1a15:	41 5f                	pop    %r15
    1a17:	c3                   	retq   
    1a18:	48 8d 0d 6a 16 00 00 	lea    0x166a(%rip),%rcx        # 3089 <_IO_stdin_used+0x89>
    1a1f:	ba 6c 00 00 00       	mov    $0x6c,%edx
    1a24:	48 8d 35 ec 15 00 00 	lea    0x15ec(%rip),%rsi        # 3017 <_IO_stdin_used+0x17>
    1a2b:	48 8d 3d 66 16 00 00 	lea    0x1666(%rip),%rdi        # 3098 <_IO_stdin_used+0x98>
    1a32:	e8 29 f6 ff ff       	callq  1060 <__assert_fail@plt>
    1a37:	48 8d 0d 4b 16 00 00 	lea    0x164b(%rip),%rcx        # 3089 <_IO_stdin_used+0x89>
    1a3e:	ba 88 00 00 00       	mov    $0x88,%edx
    1a43:	48 8d 35 cd 15 00 00 	lea    0x15cd(%rip),%rsi        # 3017 <_IO_stdin_used+0x17>
    1a4a:	48 8d 3d 62 16 00 00 	lea    0x1662(%rip),%rdi        # 30b3 <_IO_stdin_used+0xb3>
    1a51:	e8 0a f6 ff ff       	callq  1060 <__assert_fail@plt>
    1a56:	48 8d 0d 2c 16 00 00 	lea    0x162c(%rip),%rcx        # 3089 <_IO_stdin_used+0x89>
    1a5d:	ba 6d 00 00 00       	mov    $0x6d,%edx
    1a62:	48 8d 35 ae 15 00 00 	lea    0x15ae(%rip),%rsi        # 3017 <_IO_stdin_used+0x17>
    1a69:	48 8d 3d b0 16 00 00 	lea    0x16b0(%rip),%rdi        # 3120 <_IO_stdin_used+0x120>
    1a70:	e8 eb f5 ff ff       	callq  1060 <__assert_fail@plt>
    1a75:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    1a7c:	00 00 00 
    1a7f:	90                   	nop

0000000000001a80 <strlen_avx2>:
    1a80:	89 f9                	mov    %edi,%ecx
    1a82:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
    1a86:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    1a8c:	81 f9 e0 0f 00 00    	cmp    $0xfe0,%ecx
    1a92:	0f 87 e8 00 00 00    	ja     1b80 <strlen_avx2+0x100>
    1a98:	c5 fd 74 0f          	vpcmpeqb (%rdi),%ymm0,%ymm1
    1a9c:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1aa1:	0f 85 c2 00 00 00    	jne    1b69 <strlen_avx2+0xe9>
    1aa7:	83 e1 7f             	and    $0x7f,%ecx
    1aaa:	48 83 c7 20          	add    $0x20,%rdi
    1aae:	c1 f9 05             	sar    $0x5,%ecx
    1ab1:	48 83 e7 e0          	and    $0xffffffffffffffe0,%rdi
    1ab5:	ba 13 00 00 00       	mov    $0x13,%edx
    1aba:	48 8d 15 85 16 00 00 	lea    0x1685(%rip),%rdx        # 3146 <_IO_stdin_used+0x146>
    1ac1:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
    1ac5:	48 01 d1             	add    %rdx,%rcx
    1ac8:	ff e1                	jmpq   *%rcx
    1aca:	c5 fd 74 0f          	vpcmpeqb (%rdi),%ymm0,%ymm1
    1ace:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1ad3:	0f 85 90 00 00 00    	jne    1b69 <strlen_avx2+0xe9>
    1ad9:	48 83 c7 20          	add    $0x20,%rdi
    1add:	c5 fd 74 0f          	vpcmpeqb (%rdi),%ymm0,%ymm1
    1ae1:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1ae6:	0f 85 7d 00 00 00    	jne    1b69 <strlen_avx2+0xe9>
    1aec:	48 83 c7 20          	add    $0x20,%rdi
    1af0:	c5 fd 74 0f          	vpcmpeqb (%rdi),%ymm0,%ymm1
    1af4:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1af9:	75 6e                	jne    1b69 <strlen_avx2+0xe9>
    1afb:	48 83 c7 20          	add    $0x20,%rdi
    1aff:	90                   	nop
    1b00:	c5 fd 6f 0f          	vmovdqa (%rdi),%ymm1
    1b04:	c5 fd 6f 57 20       	vmovdqa 0x20(%rdi),%ymm2
    1b09:	c5 fd 6f 5f 40       	vmovdqa 0x40(%rdi),%ymm3
    1b0e:	c5 fd 6f 67 60       	vmovdqa 0x60(%rdi),%ymm4
    1b13:	c5 ed da e9          	vpminub %ymm1,%ymm2,%ymm5
    1b17:	c5 dd da f3          	vpminub %ymm3,%ymm4,%ymm6
    1b1b:	c5 cd da ed          	vpminub %ymm5,%ymm6,%ymm5
    1b1f:	c5 fd 74 ed          	vpcmpeqb %ymm5,%ymm0,%ymm5
    1b23:	48 81 c7 80 00 00 00 	add    $0x80,%rdi
    1b2a:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1b2f:	74 cf                	je     1b00 <strlen_avx2+0x80>
    1b31:	48 81 ef 80 00 00 00 	sub    $0x80,%rdi
    1b38:	c5 fd 74 c9          	vpcmpeqb %ymm1,%ymm0,%ymm1
    1b3c:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1b41:	75 26                	jne    1b69 <strlen_avx2+0xe9>
    1b43:	48 83 c7 20          	add    $0x20,%rdi
    1b47:	c5 fd 74 ca          	vpcmpeqb %ymm2,%ymm0,%ymm1
    1b4b:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1b50:	75 17                	jne    1b69 <strlen_avx2+0xe9>
    1b52:	48 83 c7 20          	add    $0x20,%rdi
    1b56:	c5 fd 74 cb          	vpcmpeqb %ymm3,%ymm0,%ymm1
    1b5a:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1b5f:	75 08                	jne    1b69 <strlen_avx2+0xe9>
    1b61:	48 83 c7 20          	add    $0x20,%rdi
    1b65:	c5 fd 74 cc          	vpcmpeqb %ymm4,%ymm0,%ymm1
    1b69:	c5 fd d7 c1          	vpmovmskb %ymm1,%eax
    1b6d:	f3 0f bc c0          	tzcnt  %eax,%eax
    1b71:	48 01 f8             	add    %rdi,%rax
    1b74:	c5 f8 77             	vzeroupper 
    1b77:	c3                   	retq   
    1b78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1b7f:	00 
    1b80:	83 e1 1f             	and    $0x1f,%ecx
    1b83:	48 83 e7 e0          	and    $0xffffffffffffffe0,%rdi
    1b87:	c5 fd 74 0f          	vpcmpeqb (%rdi),%ymm0,%ymm1
    1b8b:	c5 fd d7 c1          	vpmovmskb %ymm1,%eax
    1b8f:	c4 e2 72 f7 c0       	sarx   %ecx,%eax,%eax
    1b94:	85 c0                	test   %eax,%eax
    1b96:	0f 84 5f ff ff ff    	je     1afb <strlen_avx2+0x7b>
    1b9c:	f3 0f bc c0          	tzcnt  %eax,%eax
    1ba0:	48 01 cf             	add    %rcx,%rdi
    1ba3:	48 01 f8             	add    %rdi,%rax
    1ba6:	c5 f8 77             	vzeroupper 
    1ba9:	c3                   	retq   
    1baa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000001bb0 <strchr_avx2>:
    1bb0:	89 f9                	mov    %edi,%ecx
    1bb2:	c5 79 6e ce          	vmovd  %esi,%xmm9
    1bb6:	c4 42 7d 78 c9       	vpbroadcastb %xmm9,%ymm9
    1bbb:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
    1bbf:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    1bc5:	81 f9 e0 0f 00 00    	cmp    $0xfe0,%ecx
    1bcb:	0f 87 3f 01 00 00    	ja     1d10 <strchr_avx2+0x160>
    1bd1:	c5 fe 6f 0f          	vmovdqu (%rdi),%ymm1
    1bd5:	c5 b5 74 d1          	vpcmpeqb %ymm1,%ymm9,%ymm2
    1bd9:	c5 fd 74 c9          	vpcmpeqb %ymm1,%ymm0,%ymm1
    1bdd:	c5 ed eb c9          	vpor   %ymm1,%ymm2,%ymm1
    1be1:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1be6:	0f 85 0d 01 00 00    	jne    1cf9 <strchr_avx2+0x149>
    1bec:	48 83 c7 20          	add    $0x20,%rdi
    1bf0:	48 83 e7 e0          	and    $0xffffffffffffffe0,%rdi
    1bf4:	48 f7 c7 7f 00 00 00 	test   $0x7f,%rdi
    1bfb:	74 73                	je     1c70 <strchr_avx2+0xc0>
    1bfd:	c5 fd 6f 0f          	vmovdqa (%rdi),%ymm1
    1c01:	c5 b5 74 d1          	vpcmpeqb %ymm1,%ymm9,%ymm2
    1c05:	c5 fd 74 c9          	vpcmpeqb %ymm1,%ymm0,%ymm1
    1c09:	c5 ed eb c9          	vpor   %ymm1,%ymm2,%ymm1
    1c0d:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1c12:	0f 85 e1 00 00 00    	jne    1cf9 <strchr_avx2+0x149>
    1c18:	48 83 c7 20          	add    $0x20,%rdi
    1c1c:	48 f7 c7 7f 00 00 00 	test   $0x7f,%rdi
    1c23:	74 4b                	je     1c70 <strchr_avx2+0xc0>
    1c25:	c5 fd 6f 0f          	vmovdqa (%rdi),%ymm1
    1c29:	c5 b5 74 d1          	vpcmpeqb %ymm1,%ymm9,%ymm2
    1c2d:	c5 fd 74 c9          	vpcmpeqb %ymm1,%ymm0,%ymm1
    1c31:	c5 ed eb c9          	vpor   %ymm1,%ymm2,%ymm1
    1c35:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1c3a:	0f 85 b9 00 00 00    	jne    1cf9 <strchr_avx2+0x149>
    1c40:	48 83 c7 20          	add    $0x20,%rdi
    1c44:	48 f7 c7 7f 00 00 00 	test   $0x7f,%rdi
    1c4b:	74 23                	je     1c70 <strchr_avx2+0xc0>
    1c4d:	c5 fd 6f 0f          	vmovdqa (%rdi),%ymm1
    1c51:	c5 b5 74 d1          	vpcmpeqb %ymm1,%ymm9,%ymm2
    1c55:	c5 fd 74 c9          	vpcmpeqb %ymm1,%ymm0,%ymm1
    1c59:	c5 ed eb c9          	vpor   %ymm1,%ymm2,%ymm1
    1c5d:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1c62:	0f 85 91 00 00 00    	jne    1cf9 <strchr_avx2+0x149>
    1c68:	48 83 c7 20          	add    $0x20,%rdi
    1c6c:	0f 1f 40 00          	nopl   0x0(%rax)
    1c70:	c5 fd 6f 0f          	vmovdqa (%rdi),%ymm1
    1c74:	c5 fd 6f 57 20       	vmovdqa 0x20(%rdi),%ymm2
    1c79:	c5 b5 ef e9          	vpxor  %ymm1,%ymm9,%ymm5
    1c7d:	c5 b5 ef f2          	vpxor  %ymm2,%ymm9,%ymm6
    1c81:	c5 d5 da c9          	vpminub %ymm1,%ymm5,%ymm1
    1c85:	c5 cd da d2          	vpminub %ymm2,%ymm6,%ymm2
    1c89:	c5 fd 6f 5f 40       	vmovdqa 0x40(%rdi),%ymm3
    1c8e:	c5 ed da e9          	vpminub %ymm1,%ymm2,%ymm5
    1c92:	c5 fd 6f 67 60       	vmovdqa 0x60(%rdi),%ymm4
    1c97:	c5 b5 ef fb          	vpxor  %ymm3,%ymm9,%ymm7
    1c9b:	c5 35 ef c4          	vpxor  %ymm4,%ymm9,%ymm8
    1c9f:	c5 c5 da db          	vpminub %ymm3,%ymm7,%ymm3
    1ca3:	c5 bd da e4          	vpminub %ymm4,%ymm8,%ymm4
    1ca7:	c5 dd da f3          	vpminub %ymm3,%ymm4,%ymm6
    1cab:	c5 cd da ed          	vpminub %ymm5,%ymm6,%ymm5
    1caf:	c5 fd 74 ed          	vpcmpeqb %ymm5,%ymm0,%ymm5
    1cb3:	48 81 c7 80 00 00 00 	add    $0x80,%rdi
    1cba:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1cbf:	74 af                	je     1c70 <strchr_avx2+0xc0>
    1cc1:	48 81 ef 80 00 00 00 	sub    $0x80,%rdi
    1cc8:	c5 fd 74 c9          	vpcmpeqb %ymm1,%ymm0,%ymm1
    1ccc:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1cd1:	75 26                	jne    1cf9 <strchr_avx2+0x149>
    1cd3:	48 83 c7 20          	add    $0x20,%rdi
    1cd7:	c5 fd 74 ca          	vpcmpeqb %ymm2,%ymm0,%ymm1
    1cdb:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1ce0:	75 17                	jne    1cf9 <strchr_avx2+0x149>
    1ce2:	48 83 c7 20          	add    $0x20,%rdi
    1ce6:	c5 fd 74 cb          	vpcmpeqb %ymm3,%ymm0,%ymm1
    1cea:	c4 e2 7d 17 c9       	vptest %ymm1,%ymm1
    1cef:	75 08                	jne    1cf9 <strchr_avx2+0x149>
    1cf1:	48 83 c7 20          	add    $0x20,%rdi
    1cf5:	c5 fd 74 cc          	vpcmpeqb %ymm4,%ymm0,%ymm1
    1cf9:	c5 fd d7 c1          	vpmovmskb %ymm1,%eax
    1cfd:	f3 0f bc c0          	tzcnt  %eax,%eax
    1d01:	48 01 f8             	add    %rdi,%rax
    1d04:	c5 f8 77             	vzeroupper 
    1d07:	c3                   	retq   
    1d08:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1d0f:	00 
    1d10:	83 e1 1f             	and    $0x1f,%ecx
    1d13:	48 83 e7 e0          	and    $0xffffffffffffffe0,%rdi
    1d17:	c5 fd 6f 0f          	vmovdqa (%rdi),%ymm1
    1d1b:	c5 b5 74 d1          	vpcmpeqb %ymm1,%ymm9,%ymm2
    1d1f:	c5 fd 74 c9          	vpcmpeqb %ymm1,%ymm0,%ymm1
    1d23:	c5 ed eb c9          	vpor   %ymm1,%ymm2,%ymm1
    1d27:	c5 fd d7 c1          	vpmovmskb %ymm1,%eax
    1d2b:	c4 e2 72 f7 c0       	sarx   %ecx,%eax,%eax
    1d30:	85 c0                	test   %eax,%eax
    1d32:	0f 84 30 ff ff ff    	je     1c68 <strchr_avx2+0xb8>
    1d38:	f3 0f bc c0          	tzcnt  %eax,%eax
    1d3c:	48 01 cf             	add    %rcx,%rdi
    1d3f:	48 01 f8             	add    %rdi,%rax
    1d42:	c5 f8 77             	vzeroupper 
    1d45:	c3                   	retq   
    1d46:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    1d4d:	00 00 00 

0000000000001d50 <strcpy_avx2>:
    1d50:	89 f1                	mov    %esi,%ecx
    1d52:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
    1d56:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    1d5c:	81 f9 e0 0f 00 00    	cmp    $0xfe0,%ecx
    1d62:	0f 87 8e 01 00 00    	ja     1ef6 <strcpy_avx2+0x1a6>
    1d68:	c5 fe 6f 0e          	vmovdqu (%rsi),%ymm1
    1d6c:	c5 fd 74 e9          	vpcmpeqb %ymm1,%ymm0,%ymm5
    1d70:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1d75:	0f 85 35 01 00 00    	jne    1eb0 <strcpy_avx2+0x160>
    1d7b:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1d7f:	83 e1 1f             	and    $0x1f,%ecx
    1d82:	48 83 c6 20          	add    $0x20,%rsi
    1d86:	ba 20 00 00 00       	mov    $0x20,%edx
    1d8b:	29 ca                	sub    %ecx,%edx
    1d8d:	48 83 e6 e0          	and    $0xffffffffffffffe0,%rsi
    1d91:	48 01 d7             	add    %rdx,%rdi
    1d94:	f7 c6 7f 00 00 00    	test   $0x7f,%esi
    1d9a:	74 6d                	je     1e09 <strcpy_avx2+0xb9>
    1d9c:	c5 fd 6f 0e          	vmovdqa (%rsi),%ymm1
    1da0:	c5 fd 74 e9          	vpcmpeqb %ymm1,%ymm0,%ymm5
    1da4:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1da9:	0f 85 01 01 00 00    	jne    1eb0 <strcpy_avx2+0x160>
    1daf:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1db3:	48 83 c6 20          	add    $0x20,%rsi
    1db7:	48 83 c7 20          	add    $0x20,%rdi
    1dbb:	f7 c6 7f 00 00 00    	test   $0x7f,%esi
    1dc1:	74 46                	je     1e09 <strcpy_avx2+0xb9>
    1dc3:	c5 fd 6f 0e          	vmovdqa (%rsi),%ymm1
    1dc7:	c5 fd 74 e9          	vpcmpeqb %ymm1,%ymm0,%ymm5
    1dcb:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1dd0:	0f 85 da 00 00 00    	jne    1eb0 <strcpy_avx2+0x160>
    1dd6:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1dda:	48 83 c6 20          	add    $0x20,%rsi
    1dde:	48 83 c7 20          	add    $0x20,%rdi
    1de2:	f7 c6 7f 00 00 00    	test   $0x7f,%esi
    1de8:	74 1f                	je     1e09 <strcpy_avx2+0xb9>
    1dea:	c5 fd 6f 0e          	vmovdqa (%rsi),%ymm1
    1dee:	c5 fd 74 e9          	vpcmpeqb %ymm1,%ymm0,%ymm5
    1df2:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1df7:	0f 85 b3 00 00 00    	jne    1eb0 <strcpy_avx2+0x160>
    1dfd:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1e01:	48 83 c6 20          	add    $0x20,%rsi
    1e05:	48 83 c7 20          	add    $0x20,%rdi
    1e09:	c5 fd 6f 0e          	vmovdqa (%rsi),%ymm1
    1e0d:	c5 fd 6f 56 20       	vmovdqa 0x20(%rsi),%ymm2
    1e12:	c5 fd 6f 5e 40       	vmovdqa 0x40(%rsi),%ymm3
    1e17:	c5 fd 6f 66 60       	vmovdqa 0x60(%rsi),%ymm4
    1e1c:	c5 ed da f1          	vpminub %ymm1,%ymm2,%ymm6
    1e20:	c5 dd da fb          	vpminub %ymm3,%ymm4,%ymm7
    1e24:	c5 c5 da f6          	vpminub %ymm6,%ymm7,%ymm6
    1e28:	c5 fd 74 f6          	vpcmpeqb %ymm6,%ymm0,%ymm6
    1e2c:	c4 e2 7d 17 f6       	vptest %ymm6,%ymm6
    1e31:	75 23                	jne    1e56 <strcpy_avx2+0x106>
    1e33:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1e37:	c5 fe 7f 57 20       	vmovdqu %ymm2,0x20(%rdi)
    1e3c:	c5 fe 7f 5f 40       	vmovdqu %ymm3,0x40(%rdi)
    1e41:	c5 fe 7f 67 60       	vmovdqu %ymm4,0x60(%rdi)
    1e46:	48 81 c6 80 00 00 00 	add    $0x80,%rsi
    1e4d:	48 81 c7 80 00 00 00 	add    $0x80,%rdi
    1e54:	eb b3                	jmp    1e09 <strcpy_avx2+0xb9>
    1e56:	c5 fd 74 e9          	vpcmpeqb %ymm1,%ymm0,%ymm5
    1e5a:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1e5f:	75 4f                	jne    1eb0 <strcpy_avx2+0x160>
    1e61:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1e65:	48 83 c6 20          	add    $0x20,%rsi
    1e69:	48 83 c7 20          	add    $0x20,%rdi
    1e6d:	c5 fd 6f ca          	vmovdqa %ymm2,%ymm1
    1e71:	c5 fd 74 ea          	vpcmpeqb %ymm2,%ymm0,%ymm5
    1e75:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1e7a:	75 34                	jne    1eb0 <strcpy_avx2+0x160>
    1e7c:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1e80:	48 83 c6 20          	add    $0x20,%rsi
    1e84:	48 83 c7 20          	add    $0x20,%rdi
    1e88:	c5 fd 6f cb          	vmovdqa %ymm3,%ymm1
    1e8c:	c5 fd 74 eb          	vpcmpeqb %ymm3,%ymm0,%ymm5
    1e90:	c4 e2 7d 17 ed       	vptest %ymm5,%ymm5
    1e95:	75 19                	jne    1eb0 <strcpy_avx2+0x160>
    1e97:	c5 fe 7f 0f          	vmovdqu %ymm1,(%rdi)
    1e9b:	48 83 c6 20          	add    $0x20,%rsi
    1e9f:	48 83 c7 20          	add    $0x20,%rdi
    1ea3:	c5 fd 6f cc          	vmovdqa %ymm4,%ymm1
    1ea7:	c5 fd 74 ec          	vpcmpeqb %ymm4,%ymm0,%ymm5
    1eab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1eb0:	c5 fd d7 d5          	vpmovmskb %ymm5,%edx
    1eb4:	48 8d 47 01          	lea    0x1(%rdi),%rax
    1eb8:	89 f9                	mov    %edi,%ecx
    1eba:	f3 0f bc d2          	tzcnt  %edx,%edx
    1ebe:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    1ec4:	48 01 d0             	add    %rdx,%rax
    1ec7:	81 f9 e0 0f 00 00    	cmp    $0xfe0,%ecx
    1ecd:	77 61                	ja     1f30 <strcpy_avx2+0x1e0>
    1ecf:	67 8d 52 01          	lea    0x1(%edx),%edx
    1ed3:	c5 fe 6f 2f          	vmovdqu (%rdi),%ymm5
    1ed7:	c5 f9 6e f2          	vmovd  %edx,%xmm6
    1edb:	c4 e2 7d 78 f6       	vpbroadcastb %xmm6,%ymm6
    1ee0:	c5 cd 64 35 78 12 00 	vpcmpgtb 0x1278(%rip),%ymm6,%ymm6        # 3160 <_IO_stdin_used+0x160>
    1ee7:	00 
    1ee8:	c4 e3 55 4c e9 60    	vpblendvb %ymm6,%ymm1,%ymm5,%ymm5
    1eee:	c5 fe 7f 2f          	vmovdqu %ymm5,(%rdi)
    1ef2:	c5 f8 77             	vzeroupper 
    1ef5:	c3                   	retq   
    1ef6:	48 89 f0             	mov    %rsi,%rax
    1ef9:	48 83 e0 e0          	and    $0xffffffffffffffe0,%rax
    1efd:	c5 fe 6f 08          	vmovdqu (%rax),%ymm1
    1f01:	c5 fd 74 e9          	vpcmpeqb %ymm1,%ymm0,%ymm5
    1f05:	c5 fd d7 d5          	vpmovmskb %ymm5,%edx
    1f09:	c4 e2 72 f7 d2       	sarx   %ecx,%edx,%edx
    1f0e:	85 d2                	test   %edx,%edx
    1f10:	0f 84 52 fe ff ff    	je     1d68 <strcpy_avx2+0x18>
    1f16:	f3 0f bc d2          	tzcnt  %edx,%edx
    1f1a:	48 8d 47 01          	lea    0x1(%rdi),%rax
    1f1e:	48 01 d0             	add    %rdx,%rax
    1f21:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    1f28:	00 00 00 00 
    1f2c:	0f 1f 40 00          	nopl   0x0(%rax)
    1f30:	83 fa 0f             	cmp    $0xf,%edx
    1f33:	77 5f                	ja     1f94 <strcpy_avx2+0x244>
    1f35:	83 fa 07             	cmp    $0x7,%edx
    1f38:	77 46                	ja     1f80 <strcpy_avx2+0x230>
    1f3a:	83 fa 03             	cmp    $0x3,%edx
    1f3d:	77 31                	ja     1f70 <strcpy_avx2+0x220>
    1f3f:	74 27                	je     1f68 <strcpy_avx2+0x218>
    1f41:	83 fa 01             	cmp    $0x1,%edx
    1f44:	77 14                	ja     1f5a <strcpy_avx2+0x20a>
    1f46:	74 08                	je     1f50 <strcpy_avx2+0x200>
    1f48:	c6 07 00             	movb   $0x0,(%rdi)
    1f4b:	c5 f8 77             	vzeroupper 
    1f4e:	c3                   	retq   
    1f4f:	90                   	nop
    1f50:	0f b7 0e             	movzwl (%rsi),%ecx
    1f53:	66 89 0f             	mov    %cx,(%rdi)
    1f56:	c5 f8 77             	vzeroupper 
    1f59:	c3                   	retq   
    1f5a:	0f b7 0e             	movzwl (%rsi),%ecx
    1f5d:	66 89 0f             	mov    %cx,(%rdi)
    1f60:	c6 47 02 00          	movb   $0x0,0x2(%rdi)
    1f64:	c5 f8 77             	vzeroupper 
    1f67:	c3                   	retq   
    1f68:	8b 0e                	mov    (%rsi),%ecx
    1f6a:	89 0f                	mov    %ecx,(%rdi)
    1f6c:	c5 f8 77             	vzeroupper 
    1f6f:	c3                   	retq   
    1f70:	8b 0e                	mov    (%rsi),%ecx
    1f72:	89 0f                	mov    %ecx,(%rdi)
    1f74:	8b 4c 16 fd          	mov    -0x3(%rsi,%rdx,1),%ecx
    1f78:	89 4c 17 fd          	mov    %ecx,-0x3(%rdi,%rdx,1)
    1f7c:	c5 f8 77             	vzeroupper 
    1f7f:	c3                   	retq   
    1f80:	48 8b 0e             	mov    (%rsi),%rcx
    1f83:	4c 8b 44 16 f9       	mov    -0x7(%rsi,%rdx,1),%r8
    1f88:	48 89 0f             	mov    %rcx,(%rdi)
    1f8b:	4c 89 44 17 f9       	mov    %r8,-0x7(%rdi,%rdx,1)
    1f90:	c5 f8 77             	vzeroupper 
    1f93:	c3                   	retq   
    1f94:	c5 fa 6f 16          	vmovdqu (%rsi),%xmm2
    1f98:	c5 fa 6f 5c 16 f1    	vmovdqu -0xf(%rsi,%rdx,1),%xmm3
    1f9e:	c5 fa 7f 17          	vmovdqu %xmm2,(%rdi)
    1fa2:	c5 fa 7f 5c 17 f1    	vmovdqu %xmm3,-0xf(%rdi,%rdx,1)
    1fa8:	c5 f8 77             	vzeroupper 
    1fab:	c3                   	retq   
    1fac:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001fb0 <__libc_csu_init>:
    1fb0:	f3 0f 1e fa          	endbr64 
    1fb4:	41 57                	push   %r15
    1fb6:	4c 8d 3d a3 2d 00 00 	lea    0x2da3(%rip),%r15        # 4d60 <__frame_dummy_init_array_entry>
    1fbd:	41 56                	push   %r14
    1fbf:	49 89 d6             	mov    %rdx,%r14
    1fc2:	41 55                	push   %r13
    1fc4:	49 89 f5             	mov    %rsi,%r13
    1fc7:	41 54                	push   %r12
    1fc9:	41 89 fc             	mov    %edi,%r12d
    1fcc:	55                   	push   %rbp
    1fcd:	48 8d 2d 94 2d 00 00 	lea    0x2d94(%rip),%rbp        # 4d68 <__do_global_dtors_aux_fini_array_entry>
    1fd4:	53                   	push   %rbx
    1fd5:	4c 29 fd             	sub    %r15,%rbp
    1fd8:	48 83 ec 08          	sub    $0x8,%rsp
    1fdc:	e8 1f f0 ff ff       	callq  1000 <_init>
    1fe1:	48 c1 fd 03          	sar    $0x3,%rbp
    1fe5:	74 1f                	je     2006 <__libc_csu_init+0x56>
    1fe7:	31 db                	xor    %ebx,%ebx
    1fe9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1ff0:	4c 89 f2             	mov    %r14,%rdx
    1ff3:	4c 89 ee             	mov    %r13,%rsi
    1ff6:	44 89 e7             	mov    %r12d,%edi
    1ff9:	41 ff 14 df          	callq  *(%r15,%rbx,8)
    1ffd:	48 83 c3 01          	add    $0x1,%rbx
    2001:	48 39 dd             	cmp    %rbx,%rbp
    2004:	75 ea                	jne    1ff0 <__libc_csu_init+0x40>
    2006:	48 83 c4 08          	add    $0x8,%rsp
    200a:	5b                   	pop    %rbx
    200b:	5d                   	pop    %rbp
    200c:	41 5c                	pop    %r12
    200e:	41 5d                	pop    %r13
    2010:	41 5e                	pop    %r14
    2012:	41 5f                	pop    %r15
    2014:	c3                   	retq   
    2015:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    201c:	00 00 00 00 

0000000000002020 <__libc_csu_fini>:
    2020:	f3 0f 1e fa          	endbr64 
    2024:	c3                   	retq   

Disassembly of section .fini:

0000000000002028 <_fini>:
    2028:	f3 0f 1e fa          	endbr64 
    202c:	48 83 ec 08          	sub    $0x8,%rsp
    2030:	48 83 c4 08          	add    $0x8,%rsp
    2034:	c3                   	retq   


user/shell.o:     file format elf32-i386


Disassembly of section .text:

00000000 <mon_help>:
   0:	53                   	push   %ebx
   1:	83 ec 18             	sub    $0x18,%esp
   4:	bb 00 00 00 00       	mov    $0x0,%ebx
   9:	8b 83 04 00 00 00    	mov    0x4(%ebx),%eax
   f:	89 44 24 08          	mov    %eax,0x8(%esp)
  13:	8b 83 00 00 00 00    	mov    0x0(%ebx),%eax
  19:	89 44 24 04          	mov    %eax,0x4(%esp)
  1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  24:	e8 fc ff ff ff       	call   25 <mon_help+0x25>
  29:	83 c3 0c             	add    $0xc,%ebx
  2c:	83 fb 3c             	cmp    $0x3c,%ebx
  2f:	75 d8                	jne    9 <mon_help+0x9>
  31:	b8 00 00 00 00       	mov    $0x0,%eax
  36:	83 c4 18             	add    $0x18,%esp
  39:	5b                   	pop    %ebx
  3a:	c3                   	ret    

0000003b <chgcolor>:
  3b:	53                   	push   %ebx
  3c:	83 ec 18             	sub    $0x18,%esp
  3f:	83 7c 24 20 01       	cmpl   $0x1,0x20(%esp)
  44:	7e 35                	jle    7b <chgcolor+0x40>
  46:	8b 44 24 24          	mov    0x24(%esp),%eax
  4a:	8b 40 04             	mov    0x4(%eax),%eax
  4d:	0f b6 18             	movzbl (%eax),%ebx
  50:	83 eb 30             	sub    $0x30,%ebx
  53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  5a:	00 
  5b:	0f b6 c3             	movzbl %bl,%eax
  5e:	89 04 24             	mov    %eax,(%esp)
  61:	e8 fc ff ff ff       	call   62 <chgcolor+0x27>
  66:	0f be db             	movsbl %bl,%ebx
  69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  6d:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  74:	e8 fc ff ff ff       	call   75 <chgcolor+0x3a>
  79:	eb 0c                	jmp    87 <chgcolor+0x4c>
  7b:	c7 04 24 1b 00 00 00 	movl   $0x1b,(%esp)
  82:	e8 fc ff ff ff       	call   83 <chgcolor+0x48>
  87:	b8 00 00 00 00       	mov    $0x0,%eax
  8c:	83 c4 18             	add    $0x18,%esp
  8f:	5b                   	pop    %ebx
  90:	c3                   	ret    

00000091 <print_tick>:
  91:	83 ec 1c             	sub    $0x1c,%esp
  94:	e8 fc ff ff ff       	call   95 <print_tick+0x4>
  99:	89 44 24 04          	mov    %eax,0x4(%esp)
  9d:	c7 04 24 31 00 00 00 	movl   $0x31,(%esp)
  a4:	e8 fc ff ff ff       	call   a5 <print_tick+0x14>
  a9:	b8 00 00 00 00       	mov    $0x0,%eax
  ae:	83 c4 1c             	add    $0x1c,%esp
  b1:	c3                   	ret    

000000b2 <mem_stat>:
  b2:	83 ec 1c             	sub    $0x1c,%esp
  b5:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  bc:	00 
  bd:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  c4:	00 
  c5:	c7 04 24 49 00 00 00 	movl   $0x49,(%esp)
  cc:	e8 fc ff ff ff       	call   cd <mem_stat+0x1b>
  d1:	e8 fc ff ff ff       	call   d2 <mem_stat+0x20>
  d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  da:	c7 04 24 5e 00 00 00 	movl   $0x5e,(%esp)
  e1:	e8 fc ff ff ff       	call   e2 <mem_stat+0x30>
  e6:	e8 fc ff ff ff       	call   e7 <mem_stat+0x35>
  eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  ef:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
  f6:	e8 fc ff ff ff       	call   f7 <mem_stat+0x45>
  fb:	b8 00 00 00 00       	mov    $0x0,%eax
 100:	83 c4 1c             	add    $0x1c,%esp
 103:	c3                   	ret    

00000104 <task_job>:
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	83 ec 14             	sub    $0x14,%esp
 109:	e8 fc ff ff ff       	call   10a <task_job+0x6>
 10e:	89 c6                	mov    %eax,%esi
 110:	bb 00 00 00 00       	mov    $0x0,%ebx
 115:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 119:	89 74 24 04          	mov    %esi,0x4(%esp)
 11d:	c7 04 24 82 00 00 00 	movl   $0x82,(%esp)
 124:	e8 fc ff ff ff       	call   125 <task_job+0x21>
 129:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 130:	e8 fc ff ff ff       	call   131 <task_job+0x2d>
 135:	83 c3 01             	add    $0x1,%ebx
 138:	83 fb 0a             	cmp    $0xa,%ebx
 13b:	75 d8                	jne    115 <task_job+0x11>
 13d:	83 c4 14             	add    $0x14,%esp
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	c3                   	ret    

00000143 <forktest>:
 143:	83 ec 0c             	sub    $0xc,%esp
 146:	e8 fc ff ff ff       	call   147 <forktest+0x4>
 14b:	85 c0                	test   %eax,%eax
 14d:	75 48                	jne    197 <forktest+0x54>
 14f:	e8 fc ff ff ff       	call   150 <forktest+0xd>
 154:	e8 fc ff ff ff       	call   155 <forktest+0x12>
 159:	85 c0                	test   %eax,%eax
 15b:	74 0a                	je     167 <forktest+0x24>
 15d:	8d 76 00             	lea    0x0(%esi),%esi
 160:	e8 fc ff ff ff       	call   161 <forktest+0x1e>
 165:	eb 30                	jmp    197 <forktest+0x54>
 167:	e8 fc ff ff ff       	call   168 <forktest+0x25>
 16c:	85 c0                	test   %eax,%eax
 16e:	66 90                	xchg   %ax,%ax
 170:	74 07                	je     179 <forktest+0x36>
 172:	e8 fc ff ff ff       	call   173 <forktest+0x30>
 177:	eb 1e                	jmp    197 <forktest+0x54>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 180:	e8 fc ff ff ff       	call   181 <forktest+0x3e>
 185:	85 c0                	test   %eax,%eax
 187:	74 09                	je     192 <forktest+0x4f>
 189:	e8 fc ff ff ff       	call   18a <forktest+0x47>
 18e:	66 90                	xchg   %ax,%ax
 190:	eb 05                	jmp    197 <forktest+0x54>
 192:	e8 fc ff ff ff       	call   193 <forktest+0x50>
 197:	e8 fc ff ff ff       	call   198 <forktest+0x55>
 19c:	b8 00 00 00 00       	mov    $0x0,%eax
 1a1:	83 c4 0c             	add    $0xc,%esp
 1a4:	c3                   	ret    

000001a5 <shell>:
 1a5:	55                   	push   %ebp
 1a6:	57                   	push   %edi
 1a7:	56                   	push   %esi
 1a8:	53                   	push   %ebx
 1a9:	83 ec 5c             	sub    $0x5c,%esp
 1ac:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
 1b3:	00 00 00 
 1b6:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
 1bd:	00 00 00 
 1c0:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
 1c7:	00 00 00 
 1ca:	c7 04 24 91 00 00 00 	movl   $0x91,(%esp)
 1d1:	e8 fc ff ff ff       	call   1d2 <shell+0x2d>
 1d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1dd:	e8 fc ff ff ff       	call   1de <shell+0x39>
 1e2:	bd 67 66 66 66       	mov    $0x66666667,%ebp
 1e7:	c7 04 24 ae 00 00 00 	movl   $0xae,(%esp)
 1ee:	e8 fc ff ff ff       	call   1ef <shell+0x4a>
 1f3:	89 c3                	mov    %eax,%ebx
 1f5:	85 c0                	test   %eax,%eax
 1f7:	74 ee                	je     1e7 <shell+0x42>
 1f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fd:	a1 00 00 00 00       	mov    0x0,%eax
 202:	c1 e0 0a             	shl    $0xa,%eax
 205:	05 00 00 00 00       	add    $0x0,%eax
 20a:	89 04 24             	mov    %eax,(%esp)
 20d:	e8 fc ff ff ff       	call   20e <shell+0x69>
 212:	8b 35 00 00 00 00    	mov    0x0,%esi
 218:	83 c6 01             	add    $0x1,%esi
 21b:	89 f0                	mov    %esi,%eax
 21d:	f7 ed                	imul   %ebp
 21f:	89 d1                	mov    %edx,%ecx
 221:	c1 f9 02             	sar    $0x2,%ecx
 224:	89 f0                	mov    %esi,%eax
 226:	c1 f8 1f             	sar    $0x1f,%eax
 229:	29 c1                	sub    %eax,%ecx
 22b:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 22e:	01 c0                	add    %eax,%eax
 230:	89 f1                	mov    %esi,%ecx
 232:	29 c1                	sub    %eax,%ecx
 234:	89 0d 00 00 00 00    	mov    %ecx,0x0
 23a:	3b 0d 00 00 00 00    	cmp    0x0,%ecx
 240:	75 2a                	jne    26c <shell+0xc7>
 242:	8d 71 01             	lea    0x1(%ecx),%esi
 245:	89 f0                	mov    %esi,%eax
 247:	f7 ed                	imul   %ebp
 249:	c1 fa 02             	sar    $0x2,%edx
 24c:	89 f0                	mov    %esi,%eax
 24e:	c1 f8 1f             	sar    $0x1f,%eax
 251:	29 c2                	sub    %eax,%edx
 253:	8d 04 92             	lea    (%edx,%edx,4),%eax
 256:	01 c0                	add    %eax,%eax
 258:	29 c6                	sub    %eax,%esi
 25a:	89 35 00 00 00 00    	mov    %esi,0x0
 260:	89 c8                	mov    %ecx,%eax
 262:	c1 e0 0a             	shl    $0xa,%eax
 265:	c6 80 00 00 00 00 00 	movb   $0x0,0x0(%eax)
 26c:	89 0d 00 00 00 00    	mov    %ecx,0x0
 272:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
 279:	00 
 27a:	be 00 00 00 00       	mov    $0x0,%esi
 27f:	eb 06                	jmp    287 <shell+0xe2>
 281:	c6 03 00             	movb   $0x0,(%ebx)
 284:	83 c3 01             	add    $0x1,%ebx
 287:	0f b6 03             	movzbl (%ebx),%eax
 28a:	84 c0                	test   %al,%al
 28c:	74 70                	je     2fe <shell+0x159>
 28e:	0f be c0             	movsbl %al,%eax
 291:	89 44 24 04          	mov    %eax,0x4(%esp)
 295:	c7 04 24 b5 00 00 00 	movl   $0xb5,(%esp)
 29c:	e8 fc ff ff ff       	call   29d <shell+0xf8>
 2a1:	85 c0                	test   %eax,%eax
 2a3:	75 dc                	jne    281 <shell+0xdc>
 2a5:	80 3b 00             	cmpb   $0x0,(%ebx)
 2a8:	74 54                	je     2fe <shell+0x159>
 2aa:	83 fe 0f             	cmp    $0xf,%esi
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
 2b0:	75 19                	jne    2cb <shell+0x126>
 2b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
 2b9:	00 
 2ba:	c7 04 24 ba 00 00 00 	movl   $0xba,(%esp)
 2c1:	e8 fc ff ff ff       	call   2c2 <shell+0x11d>
 2c6:	e9 1c ff ff ff       	jmp    1e7 <shell+0x42>
 2cb:	89 5c b4 10          	mov    %ebx,0x10(%esp,%esi,4)
 2cf:	83 c6 01             	add    $0x1,%esi
 2d2:	0f b6 03             	movzbl (%ebx),%eax
 2d5:	84 c0                	test   %al,%al
 2d7:	75 0c                	jne    2e5 <shell+0x140>
 2d9:	eb ac                	jmp    287 <shell+0xe2>
 2db:	83 c3 01             	add    $0x1,%ebx
 2de:	0f b6 03             	movzbl (%ebx),%eax
 2e1:	84 c0                	test   %al,%al
 2e3:	74 a2                	je     287 <shell+0xe2>
 2e5:	0f be c0             	movsbl %al,%eax
 2e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ec:	c7 04 24 b5 00 00 00 	movl   $0xb5,(%esp)
 2f3:	e8 fc ff ff ff       	call   2f4 <shell+0x14f>
 2f8:	85 c0                	test   %eax,%eax
 2fa:	74 df                	je     2db <shell+0x136>
 2fc:	eb 89                	jmp    287 <shell+0xe2>
 2fe:	c7 44 b4 10 00 00 00 	movl   $0x0,0x10(%esp,%esi,4)
 305:	00 
 306:	85 f6                	test   %esi,%esi
 308:	0f 84 d9 fe ff ff    	je     1e7 <shell+0x42>
 30e:	bb 00 00 00 00       	mov    $0x0,%ebx
 313:	bf 00 00 00 00       	mov    $0x0,%edi
 318:	8b 03                	mov    (%ebx),%eax
 31a:	89 44 24 04          	mov    %eax,0x4(%esp)
 31e:	8b 44 24 10          	mov    0x10(%esp),%eax
 322:	89 04 24             	mov    %eax,(%esp)
 325:	e8 fc ff ff ff       	call   326 <shell+0x181>
 32a:	85 c0                	test   %eax,%eax
 32c:	75 1d                	jne    34b <shell+0x1a6>
 32e:	6b ff 0c             	imul   $0xc,%edi,%edi
 331:	8d 44 24 10          	lea    0x10(%esp),%eax
 335:	89 44 24 04          	mov    %eax,0x4(%esp)
 339:	89 34 24             	mov    %esi,(%esp)
 33c:	ff 97 08 00 00 00    	call   *0x8(%edi)
 342:	85 c0                	test   %eax,%eax
 344:	78 29                	js     36f <shell+0x1ca>
 346:	e9 9c fe ff ff       	jmp    1e7 <shell+0x42>
 34b:	83 c7 01             	add    $0x1,%edi
 34e:	83 c3 0c             	add    $0xc,%ebx
 351:	83 ff 05             	cmp    $0x5,%edi
 354:	75 c2                	jne    318 <shell+0x173>
 356:	8b 44 24 10          	mov    0x10(%esp),%eax
 35a:	89 44 24 04          	mov    %eax,0x4(%esp)
 35e:	c7 04 24 d7 00 00 00 	movl   $0xd7,(%esp)
 365:	e8 fc ff ff ff       	call   366 <shell+0x1c1>
 36a:	e9 78 fe ff ff       	jmp    1e7 <shell+0x42>
 36f:	83 c4 5c             	add    $0x5c,%esp
 372:	5b                   	pop    %ebx
 373:	5e                   	pop    %esi
 374:	5f                   	pop    %edi
 375:	5d                   	pop    %ebp
 376:	c3                   	ret    


kernel/system:     file format elf32-i386


Disassembly of section .text:

f0100000 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0100000:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0100004:	b8 00 00 00 00       	mov    $0x0,%eax
f0100009:	80 3a 00             	cmpb   $0x0,(%edx)
f010000c:	74 09                	je     f0100017 <strlen+0x17>
		n++;
f010000e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0100011:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0100015:	75 f7                	jne    f010000e <strlen+0xe>
		n++;
	return n;
}
f0100017:	f3 c3                	repz ret 

f0100019 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0100019:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f010001d:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0100021:	b8 00 00 00 00       	mov    $0x0,%eax
f0100026:	85 d2                	test   %edx,%edx
f0100028:	74 12                	je     f010003c <strnlen+0x23>
f010002a:	80 39 00             	cmpb   $0x0,(%ecx)
f010002d:	74 0d                	je     f010003c <strnlen+0x23>
		n++;
f010002f:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0100032:	39 d0                	cmp    %edx,%eax
f0100034:	74 06                	je     f010003c <strnlen+0x23>
f0100036:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010003a:	75 f3                	jne    f010002f <strnlen+0x16>
		n++;
	return n;
}
f010003c:	f3 c3                	repz ret 

f010003e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010003e:	53                   	push   %ebx
f010003f:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100043:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0100047:	ba 00 00 00 00       	mov    $0x0,%edx
f010004c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0100050:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0100053:	83 c2 01             	add    $0x1,%edx
f0100056:	84 c9                	test   %cl,%cl
f0100058:	75 f2                	jne    f010004c <strcpy+0xe>
		/* do nothing */;
	return ret;
}
f010005a:	5b                   	pop    %ebx
f010005b:	c3                   	ret    

f010005c <strcat>:

char *
strcat(char *dst, const char *src)
{
f010005c:	53                   	push   %ebx
f010005d:	83 ec 08             	sub    $0x8,%esp
f0100060:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int len = strlen(dst);
f0100064:	89 1c 24             	mov    %ebx,(%esp)
f0100067:	e8 94 ff ff ff       	call   f0100000 <strlen>
	strcpy(dst + len, src);
f010006c:	8b 54 24 14          	mov    0x14(%esp),%edx
f0100070:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100074:	8d 04 03             	lea    (%ebx,%eax,1),%eax
f0100077:	89 04 24             	mov    %eax,(%esp)
f010007a:	e8 bf ff ff ff       	call   f010003e <strcpy>
	return dst;
}
f010007f:	89 d8                	mov    %ebx,%eax
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	5b                   	pop    %ebx
f0100085:	c3                   	ret    

f0100086 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0100086:	56                   	push   %esi
f0100087:	53                   	push   %ebx
f0100088:	8b 44 24 0c          	mov    0xc(%esp),%eax
f010008c:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100090:	8b 74 24 14          	mov    0x14(%esp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0100094:	85 f6                	test   %esi,%esi
f0100096:	74 18                	je     f01000b0 <strncpy+0x2a>
f0100098:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f010009d:	0f b6 1a             	movzbl (%edx),%ebx
f01000a0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01000a3:	80 3a 01             	cmpb   $0x1,(%edx)
f01000a6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01000a9:	83 c1 01             	add    $0x1,%ecx
f01000ac:	39 ce                	cmp    %ecx,%esi
f01000ae:	77 ed                	ja     f010009d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f01000b0:	5b                   	pop    %ebx
f01000b1:	5e                   	pop    %esi
f01000b2:	c3                   	ret    

f01000b3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01000b3:	57                   	push   %edi
f01000b4:	56                   	push   %esi
f01000b5:	53                   	push   %ebx
f01000b6:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01000ba:	8b 5c 24 14          	mov    0x14(%esp),%ebx
f01000be:	8b 74 24 18          	mov    0x18(%esp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01000c2:	89 f8                	mov    %edi,%eax
f01000c4:	85 f6                	test   %esi,%esi
f01000c6:	74 2c                	je     f01000f4 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
f01000c8:	83 fe 01             	cmp    $0x1,%esi
f01000cb:	74 24                	je     f01000f1 <strlcpy+0x3e>
f01000cd:	0f b6 0b             	movzbl (%ebx),%ecx
f01000d0:	84 c9                	test   %cl,%cl
f01000d2:	74 1d                	je     f01000f1 <strlcpy+0x3e>
f01000d4:	ba 00 00 00 00       	mov    $0x0,%edx
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
f01000d9:	83 ee 02             	sub    $0x2,%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01000dc:	88 08                	mov    %cl,(%eax)
f01000de:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01000e1:	39 f2                	cmp    %esi,%edx
f01000e3:	74 0c                	je     f01000f1 <strlcpy+0x3e>
f01000e5:	0f b6 4c 13 01       	movzbl 0x1(%ebx,%edx,1),%ecx
f01000ea:	83 c2 01             	add    $0x1,%edx
f01000ed:	84 c9                	test   %cl,%cl
f01000ef:	75 eb                	jne    f01000dc <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
f01000f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01000f4:	29 f8                	sub    %edi,%eax
}
f01000f6:	5b                   	pop    %ebx
f01000f7:	5e                   	pop    %esi
f01000f8:	5f                   	pop    %edi
f01000f9:	c3                   	ret    

f01000fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01000fa:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f01000fe:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
f0100102:	0f b6 01             	movzbl (%ecx),%eax
f0100105:	84 c0                	test   %al,%al
f0100107:	74 15                	je     f010011e <strcmp+0x24>
f0100109:	3a 02                	cmp    (%edx),%al
f010010b:	75 11                	jne    f010011e <strcmp+0x24>
		p++, q++;
f010010d:	83 c1 01             	add    $0x1,%ecx
f0100110:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0100113:	0f b6 01             	movzbl (%ecx),%eax
f0100116:	84 c0                	test   %al,%al
f0100118:	74 04                	je     f010011e <strcmp+0x24>
f010011a:	3a 02                	cmp    (%edx),%al
f010011c:	74 ef                	je     f010010d <strcmp+0x13>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010011e:	0f b6 c0             	movzbl %al,%eax
f0100121:	0f b6 12             	movzbl (%edx),%edx
f0100124:	29 d0                	sub    %edx,%eax
}
f0100126:	c3                   	ret    

f0100127 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0100127:	53                   	push   %ebx
f0100128:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f010012c:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
f0100130:	8b 54 24 10          	mov    0x10(%esp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f0100134:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0100139:	85 d2                	test   %edx,%edx
f010013b:	74 28                	je     f0100165 <strncmp+0x3e>
f010013d:	0f b6 01             	movzbl (%ecx),%eax
f0100140:	84 c0                	test   %al,%al
f0100142:	74 23                	je     f0100167 <strncmp+0x40>
f0100144:	3a 03                	cmp    (%ebx),%al
f0100146:	75 1f                	jne    f0100167 <strncmp+0x40>
f0100148:	83 ea 01             	sub    $0x1,%edx
f010014b:	74 13                	je     f0100160 <strncmp+0x39>
		n--, p++, q++;
f010014d:	83 c1 01             	add    $0x1,%ecx
f0100150:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0100153:	0f b6 01             	movzbl (%ecx),%eax
f0100156:	84 c0                	test   %al,%al
f0100158:	74 0d                	je     f0100167 <strncmp+0x40>
f010015a:	3a 03                	cmp    (%ebx),%al
f010015c:	74 ea                	je     f0100148 <strncmp+0x21>
f010015e:	eb 07                	jmp    f0100167 <strncmp+0x40>
		n--, p++, q++;
	if (n == 0)
		return 0;
f0100160:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0100165:	5b                   	pop    %ebx
f0100166:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0100167:	0f b6 01             	movzbl (%ecx),%eax
f010016a:	0f b6 13             	movzbl (%ebx),%edx
f010016d:	29 d0                	sub    %edx,%eax
f010016f:	eb f4                	jmp    f0100165 <strncmp+0x3e>

f0100171 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0100171:	8b 44 24 04          	mov    0x4(%esp),%eax
f0100175:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
f010017a:	0f b6 10             	movzbl (%eax),%edx
f010017d:	84 d2                	test   %dl,%dl
f010017f:	74 21                	je     f01001a2 <strchr+0x31>
		if (*s == c)
f0100181:	38 ca                	cmp    %cl,%dl
f0100183:	75 0d                	jne    f0100192 <strchr+0x21>
f0100185:	f3 c3                	repz ret 
f0100187:	38 ca                	cmp    %cl,%dl
f0100189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0100190:	74 15                	je     f01001a7 <strchr+0x36>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0100192:	83 c0 01             	add    $0x1,%eax
f0100195:	0f b6 10             	movzbl (%eax),%edx
f0100198:	84 d2                	test   %dl,%dl
f010019a:	75 eb                	jne    f0100187 <strchr+0x16>
		if (*s == c)
			return (char *) s;
	return 0;
f010019c:	b8 00 00 00 00       	mov    $0x0,%eax
f01001a1:	c3                   	ret    
f01001a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01001a7:	f3 c3                	repz ret 

f01001a9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01001a9:	8b 44 24 04          	mov    0x4(%esp),%eax
f01001ad:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
f01001b2:	0f b6 10             	movzbl (%eax),%edx
f01001b5:	84 d2                	test   %dl,%dl
f01001b7:	74 14                	je     f01001cd <strfind+0x24>
		if (*s == c)
f01001b9:	38 ca                	cmp    %cl,%dl
f01001bb:	75 06                	jne    f01001c3 <strfind+0x1a>
f01001bd:	f3 c3                	repz ret 
f01001bf:	38 ca                	cmp    %cl,%dl
f01001c1:	74 0a                	je     f01001cd <strfind+0x24>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01001c3:	83 c0 01             	add    $0x1,%eax
f01001c6:	0f b6 10             	movzbl (%eax),%edx
f01001c9:	84 d2                	test   %dl,%dl
f01001cb:	75 f2                	jne    f01001bf <strfind+0x16>
		if (*s == c)
			break;
	return (char *) s;
}
f01001cd:	f3 c3                	repz ret 

f01001cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01001cf:	83 ec 0c             	sub    $0xc,%esp
f01001d2:	89 1c 24             	mov    %ebx,(%esp)
f01001d5:	89 74 24 04          	mov    %esi,0x4(%esp)
f01001d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01001dd:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01001e1:	8b 44 24 14          	mov    0x14(%esp),%eax
f01001e5:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	if (n == 0)
f01001e9:	85 c9                	test   %ecx,%ecx
f01001eb:	74 30                	je     f010021d <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01001ed:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01001f3:	75 25                	jne    f010021a <memset+0x4b>
f01001f5:	f6 c1 03             	test   $0x3,%cl
f01001f8:	75 20                	jne    f010021a <memset+0x4b>
		c &= 0xFF;
f01001fa:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01001fd:	89 d3                	mov    %edx,%ebx
f01001ff:	c1 e3 08             	shl    $0x8,%ebx
f0100202:	89 d6                	mov    %edx,%esi
f0100204:	c1 e6 18             	shl    $0x18,%esi
f0100207:	89 d0                	mov    %edx,%eax
f0100209:	c1 e0 10             	shl    $0x10,%eax
f010020c:	09 f0                	or     %esi,%eax
f010020e:	09 d0                	or     %edx,%eax
f0100210:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0100212:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f0100215:	fc                   	cld    
f0100216:	f3 ab                	rep stos %eax,%es:(%edi)
f0100218:	eb 03                	jmp    f010021d <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010021a:	fc                   	cld    
f010021b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010021d:	89 f8                	mov    %edi,%eax
f010021f:	8b 1c 24             	mov    (%esp),%ebx
f0100222:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100226:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010022a:	83 c4 0c             	add    $0xc,%esp
f010022d:	c3                   	ret    

f010022e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010022e:	83 ec 08             	sub    $0x8,%esp
f0100231:	89 34 24             	mov    %esi,(%esp)
f0100234:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100238:	8b 44 24 0c          	mov    0xc(%esp),%eax
f010023c:	8b 74 24 10          	mov    0x10(%esp),%esi
f0100240:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0100244:	39 c6                	cmp    %eax,%esi
f0100246:	73 36                	jae    f010027e <memmove+0x50>
f0100248:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010024b:	39 d0                	cmp    %edx,%eax
f010024d:	73 2f                	jae    f010027e <memmove+0x50>
		s += n;
		d += n;
f010024f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0100252:	f6 c2 03             	test   $0x3,%dl
f0100255:	75 1b                	jne    f0100272 <memmove+0x44>
f0100257:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010025d:	75 13                	jne    f0100272 <memmove+0x44>
f010025f:	f6 c1 03             	test   $0x3,%cl
f0100262:	75 0e                	jne    f0100272 <memmove+0x44>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0100264:	83 ef 04             	sub    $0x4,%edi
f0100267:	8d 72 fc             	lea    -0x4(%edx),%esi
f010026a:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f010026d:	fd                   	std    
f010026e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0100270:	eb 09                	jmp    f010027b <memmove+0x4d>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0100272:	83 ef 01             	sub    $0x1,%edi
f0100275:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0100278:	fd                   	std    
f0100279:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010027b:	fc                   	cld    
f010027c:	eb 20                	jmp    f010029e <memmove+0x70>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010027e:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0100284:	75 13                	jne    f0100299 <memmove+0x6b>
f0100286:	a8 03                	test   $0x3,%al
f0100288:	75 0f                	jne    f0100299 <memmove+0x6b>
f010028a:	f6 c1 03             	test   $0x3,%cl
f010028d:	75 0a                	jne    f0100299 <memmove+0x6b>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010028f:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f0100292:	89 c7                	mov    %eax,%edi
f0100294:	fc                   	cld    
f0100295:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0100297:	eb 05                	jmp    f010029e <memmove+0x70>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0100299:	89 c7                	mov    %eax,%edi
f010029b:	fc                   	cld    
f010029c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010029e:	8b 34 24             	mov    (%esp),%esi
f01002a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01002a5:	83 c4 08             	add    $0x8,%esp
f01002a8:	c3                   	ret    

f01002a9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01002a9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f01002ac:	8b 44 24 18          	mov    0x18(%esp),%eax
f01002b0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002b4:	8b 44 24 14          	mov    0x14(%esp),%eax
f01002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002bc:	8b 44 24 10          	mov    0x10(%esp),%eax
f01002c0:	89 04 24             	mov    %eax,(%esp)
f01002c3:	e8 66 ff ff ff       	call   f010022e <memmove>
}
f01002c8:	83 c4 0c             	add    $0xc,%esp
f01002cb:	c3                   	ret    

f01002cc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01002cc:	57                   	push   %edi
f01002cd:	56                   	push   %esi
f01002ce:	53                   	push   %ebx
f01002cf:	8b 5c 24 10          	mov    0x10(%esp),%ebx
f01002d3:	8b 74 24 14          	mov    0x14(%esp),%esi
f01002d7:	8b 7c 24 18          	mov    0x18(%esp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01002db:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01002e0:	85 ff                	test   %edi,%edi
f01002e2:	74 38                	je     f010031c <memcmp+0x50>
		if (*s1 != *s2)
f01002e4:	0f b6 03             	movzbl (%ebx),%eax
f01002e7:	0f b6 0e             	movzbl (%esi),%ecx
f01002ea:	38 c8                	cmp    %cl,%al
f01002ec:	74 1d                	je     f010030b <memcmp+0x3f>
f01002ee:	eb 11                	jmp    f0100301 <memcmp+0x35>
f01002f0:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
f01002f5:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
f01002fa:	83 c2 01             	add    $0x1,%edx
f01002fd:	38 c8                	cmp    %cl,%al
f01002ff:	74 12                	je     f0100313 <memcmp+0x47>
			return (int) *s1 - (int) *s2;
f0100301:	0f b6 c0             	movzbl %al,%eax
f0100304:	0f b6 c9             	movzbl %cl,%ecx
f0100307:	29 c8                	sub    %ecx,%eax
f0100309:	eb 11                	jmp    f010031c <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010030b:	83 ef 01             	sub    $0x1,%edi
f010030e:	ba 00 00 00 00       	mov    $0x0,%edx
f0100313:	39 fa                	cmp    %edi,%edx
f0100315:	75 d9                	jne    f01002f0 <memcmp+0x24>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f0100317:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010031c:	5b                   	pop    %ebx
f010031d:	5e                   	pop    %esi
f010031e:	5f                   	pop    %edi
f010031f:	c3                   	ret    

f0100320 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0100320:	8b 44 24 04          	mov    0x4(%esp),%eax
	const void *ends = (const char *) s + n;
f0100324:	89 c2                	mov    %eax,%edx
f0100326:	03 54 24 0c          	add    0xc(%esp),%edx
	for (; s < ends; s++)
f010032a:	39 d0                	cmp    %edx,%eax
f010032c:	73 16                	jae    f0100344 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f010032e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
f0100333:	38 08                	cmp    %cl,(%eax)
f0100335:	75 06                	jne    f010033d <memfind+0x1d>
f0100337:	f3 c3                	repz ret 
f0100339:	38 08                	cmp    %cl,(%eax)
f010033b:	74 07                	je     f0100344 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f010033d:	83 c0 01             	add    $0x1,%eax
f0100340:	39 c2                	cmp    %eax,%edx
f0100342:	77 f5                	ja     f0100339 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0100344:	f3 c3                	repz ret 

f0100346 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0100346:	55                   	push   %ebp
f0100347:	57                   	push   %edi
f0100348:	56                   	push   %esi
f0100349:	53                   	push   %ebx
f010034a:	8b 54 24 14          	mov    0x14(%esp),%edx
f010034e:	8b 74 24 18          	mov    0x18(%esp),%esi
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0100352:	0f b6 02             	movzbl (%edx),%eax
f0100355:	3c 20                	cmp    $0x20,%al
f0100357:	74 04                	je     f010035d <strtol+0x17>
f0100359:	3c 09                	cmp    $0x9,%al
f010035b:	75 0e                	jne    f010036b <strtol+0x25>
		s++;
f010035d:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0100360:	0f b6 02             	movzbl (%edx),%eax
f0100363:	3c 20                	cmp    $0x20,%al
f0100365:	74 f6                	je     f010035d <strtol+0x17>
f0100367:	3c 09                	cmp    $0x9,%al
f0100369:	74 f2                	je     f010035d <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
f010036b:	3c 2b                	cmp    $0x2b,%al
f010036d:	75 0a                	jne    f0100379 <strtol+0x33>
		s++;
f010036f:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0100372:	bf 00 00 00 00       	mov    $0x0,%edi
f0100377:	eb 10                	jmp    f0100389 <strtol+0x43>
f0100379:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f010037e:	3c 2d                	cmp    $0x2d,%al
f0100380:	75 07                	jne    f0100389 <strtol+0x43>
		s++, neg = 1;
f0100382:	83 c2 01             	add    $0x1,%edx
f0100385:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0100389:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
f010038e:	0f 94 c0             	sete   %al
f0100391:	74 07                	je     f010039a <strtol+0x54>
f0100393:	83 7c 24 1c 10       	cmpl   $0x10,0x1c(%esp)
f0100398:	75 18                	jne    f01003b2 <strtol+0x6c>
f010039a:	80 3a 30             	cmpb   $0x30,(%edx)
f010039d:	75 13                	jne    f01003b2 <strtol+0x6c>
f010039f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01003a3:	75 0d                	jne    f01003b2 <strtol+0x6c>
		s += 2, base = 16;
f01003a5:	83 c2 02             	add    $0x2,%edx
f01003a8:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
f01003af:	00 
f01003b0:	eb 1c                	jmp    f01003ce <strtol+0x88>
	else if (base == 0 && s[0] == '0')
f01003b2:	84 c0                	test   %al,%al
f01003b4:	74 18                	je     f01003ce <strtol+0x88>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01003b6:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
f01003bd:	00 
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f01003be:	80 3a 30             	cmpb   $0x30,(%edx)
f01003c1:	75 0b                	jne    f01003ce <strtol+0x88>
		s++, base = 8;
f01003c3:	83 c2 01             	add    $0x1,%edx
f01003c6:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
f01003cd:	00 
	else if (base == 0)
		base = 10;
f01003ce:	b8 00 00 00 00       	mov    $0x0,%eax

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f01003d3:	0f b6 0a             	movzbl (%edx),%ecx
f01003d6:	8d 69 d0             	lea    -0x30(%ecx),%ebp
f01003d9:	89 eb                	mov    %ebp,%ebx
f01003db:	80 fb 09             	cmp    $0x9,%bl
f01003de:	77 08                	ja     f01003e8 <strtol+0xa2>
			dig = *s - '0';
f01003e0:	0f be c9             	movsbl %cl,%ecx
f01003e3:	83 e9 30             	sub    $0x30,%ecx
f01003e6:	eb 22                	jmp    f010040a <strtol+0xc4>
		else if (*s >= 'a' && *s <= 'z')
f01003e8:	8d 69 9f             	lea    -0x61(%ecx),%ebp
f01003eb:	89 eb                	mov    %ebp,%ebx
f01003ed:	80 fb 19             	cmp    $0x19,%bl
f01003f0:	77 08                	ja     f01003fa <strtol+0xb4>
			dig = *s - 'a' + 10;
f01003f2:	0f be c9             	movsbl %cl,%ecx
f01003f5:	83 e9 57             	sub    $0x57,%ecx
f01003f8:	eb 10                	jmp    f010040a <strtol+0xc4>
		else if (*s >= 'A' && *s <= 'Z')
f01003fa:	8d 69 bf             	lea    -0x41(%ecx),%ebp
f01003fd:	89 eb                	mov    %ebp,%ebx
f01003ff:	80 fb 19             	cmp    $0x19,%bl
f0100402:	77 19                	ja     f010041d <strtol+0xd7>
			dig = *s - 'A' + 10;
f0100404:	0f be c9             	movsbl %cl,%ecx
f0100407:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f010040a:	3b 4c 24 1c          	cmp    0x1c(%esp),%ecx
f010040e:	7d 11                	jge    f0100421 <strtol+0xdb>
			break;
		s++, val = (val * base) + dig;
f0100410:	83 c2 01             	add    $0x1,%edx
f0100413:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
f0100418:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f010041b:	eb b6                	jmp    f01003d3 <strtol+0x8d>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
f010041d:	89 c1                	mov    %eax,%ecx
f010041f:	eb 02                	jmp    f0100423 <strtol+0xdd>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0100421:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
f0100423:	85 f6                	test   %esi,%esi
f0100425:	74 02                	je     f0100429 <strtol+0xe3>
		*endptr = (char *) s;
f0100427:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f0100429:	89 ca                	mov    %ecx,%edx
f010042b:	f7 da                	neg    %edx
f010042d:	85 ff                	test   %edi,%edi
f010042f:	0f 45 c2             	cmovne %edx,%eax
}
f0100432:	5b                   	pop    %ebx
f0100433:	5e                   	pop    %esi
f0100434:	5f                   	pop    %edi
f0100435:	5d                   	pop    %ebp
f0100436:	c3                   	ret    
	...

f0100438 <putch>:
f0100438:	53                   	push   %ebx
f0100439:	83 ec 18             	sub    $0x18,%esp
f010043c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f0100440:	8b 03                	mov    (%ebx),%eax
f0100442:	8b 54 24 20          	mov    0x20(%esp),%edx
f0100446:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
f010044a:	83 c0 01             	add    $0x1,%eax
f010044d:	89 03                	mov    %eax,(%ebx)
f010044f:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100454:	75 19                	jne    f010046f <putch+0x37>
f0100456:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f010045d:	00 
f010045e:	8d 43 08             	lea    0x8(%ebx),%eax
f0100461:	89 04 24             	mov    %eax,(%esp)
f0100464:	e8 d0 0a 00 00       	call   f0100f39 <puts>
f0100469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
f010046f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
f0100473:	83 c4 18             	add    $0x18,%esp
f0100476:	5b                   	pop    %ebx
f0100477:	c3                   	ret    

f0100478 <vcprintf>:
f0100478:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
f010047e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
f0100485:	00 
f0100486:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
f010048d:	00 
f010048e:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
f0100495:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100499:	8b 84 24 30 01 00 00 	mov    0x130(%esp),%eax
f01004a0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01004a4:	8d 44 24 18          	lea    0x18(%esp),%eax
f01004a8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004ac:	c7 04 24 38 04 10 f0 	movl   $0xf0100438,(%esp)
f01004b3:	e8 b7 01 00 00       	call   f010066f <vprintfmt>
f01004b8:	8b 44 24 18          	mov    0x18(%esp),%eax
f01004bc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004c0:	8d 44 24 20          	lea    0x20(%esp),%eax
f01004c4:	89 04 24             	mov    %eax,(%esp)
f01004c7:	e8 6d 0a 00 00       	call   f0100f39 <puts>
f01004cc:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f01004d0:	81 c4 2c 01 00 00    	add    $0x12c,%esp
f01004d6:	c3                   	ret    

f01004d7 <cprintf>:
f01004d7:	83 ec 1c             	sub    $0x1c,%esp
f01004da:	8d 44 24 24          	lea    0x24(%esp),%eax
f01004de:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004e2:	8b 44 24 20          	mov    0x20(%esp),%eax
f01004e6:	89 04 24             	mov    %eax,(%esp)
f01004e9:	e8 8a ff ff ff       	call   f0100478 <vcprintf>
f01004ee:	83 c4 1c             	add    $0x1c,%esp
f01004f1:	c3                   	ret    
	...

f0100500 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100500:	55                   	push   %ebp
f0100501:	57                   	push   %edi
f0100502:	56                   	push   %esi
f0100503:	53                   	push   %ebx
f0100504:	83 ec 3c             	sub    $0x3c,%esp
f0100507:	89 c5                	mov    %eax,%ebp
f0100509:	89 d6                	mov    %edx,%esi
f010050b:	8b 44 24 50          	mov    0x50(%esp),%eax
f010050f:	89 44 24 24          	mov    %eax,0x24(%esp)
f0100513:	8b 54 24 54          	mov    0x54(%esp),%edx
f0100517:	89 54 24 20          	mov    %edx,0x20(%esp)
f010051b:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
f010051f:	8b 7c 24 60          	mov    0x60(%esp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100523:	b8 00 00 00 00       	mov    $0x0,%eax
f0100528:	39 d0                	cmp    %edx,%eax
f010052a:	72 13                	jb     f010053f <printnum+0x3f>
f010052c:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0100530:	39 4c 24 58          	cmp    %ecx,0x58(%esp)
f0100534:	76 09                	jbe    f010053f <printnum+0x3f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0100536:	83 eb 01             	sub    $0x1,%ebx
f0100539:	85 db                	test   %ebx,%ebx
f010053b:	7f 63                	jg     f01005a0 <printnum+0xa0>
f010053d:	eb 71                	jmp    f01005b0 <printnum+0xb0>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010053f:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0100543:	83 eb 01             	sub    $0x1,%ebx
f0100546:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010054a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
f010054e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100552:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100556:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010055a:	89 44 24 28          	mov    %eax,0x28(%esp)
f010055e:	89 54 24 2c          	mov    %edx,0x2c(%esp)
f0100562:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0100569:	00 
f010056a:	8b 54 24 24          	mov    0x24(%esp),%edx
f010056e:	89 14 24             	mov    %edx,(%esp)
f0100571:	8b 4c 24 20          	mov    0x20(%esp),%ecx
f0100575:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100579:	e8 62 0f 00 00       	call   f01014e0 <__udivdi3>
f010057e:	8b 4c 24 28          	mov    0x28(%esp),%ecx
f0100582:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
f0100586:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010058a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010058e:	89 04 24             	mov    %eax,(%esp)
f0100591:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100595:	89 f2                	mov    %esi,%edx
f0100597:	89 e8                	mov    %ebp,%eax
f0100599:	e8 62 ff ff ff       	call   f0100500 <printnum>
f010059e:	eb 10                	jmp    f01005b0 <printnum+0xb0>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01005a0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005a4:	89 3c 24             	mov    %edi,(%esp)
f01005a7:	ff d5                	call   *%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01005a9:	83 eb 01             	sub    $0x1,%ebx
f01005ac:	85 db                	test   %ebx,%ebx
f01005ae:	7f f0                	jg     f01005a0 <printnum+0xa0>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01005b0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005b4:	8b 74 24 04          	mov    0x4(%esp),%esi
f01005b8:	8b 44 24 58          	mov    0x58(%esp),%eax
f01005bc:	89 44 24 08          	mov    %eax,0x8(%esp)
f01005c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01005c7:	00 
f01005c8:	8b 54 24 24          	mov    0x24(%esp),%edx
f01005cc:	89 14 24             	mov    %edx,(%esp)
f01005cf:	8b 4c 24 20          	mov    0x20(%esp),%ecx
f01005d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01005d7:	e8 84 10 00 00       	call   f0101660 <__umoddi3>
f01005dc:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005e0:	0f be 80 88 51 10 f0 	movsbl -0xfefae78(%eax),%eax
f01005e7:	89 04 24             	mov    %eax,(%esp)
f01005ea:	ff d5                	call   *%ebp
}
f01005ec:	83 c4 3c             	add    $0x3c,%esp
f01005ef:	5b                   	pop    %ebx
f01005f0:	5e                   	pop    %esi
f01005f1:	5f                   	pop    %edi
f01005f2:	5d                   	pop    %ebp
f01005f3:	c3                   	ret    

f01005f4 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01005f4:	83 fa 01             	cmp    $0x1,%edx
f01005f7:	7e 0d                	jle    f0100606 <getuint+0x12>
		return va_arg(*ap, unsigned long long);
f01005f9:	8b 10                	mov    (%eax),%edx
f01005fb:	8d 4a 08             	lea    0x8(%edx),%ecx
f01005fe:	89 08                	mov    %ecx,(%eax)
f0100600:	8b 02                	mov    (%edx),%eax
f0100602:	8b 52 04             	mov    0x4(%edx),%edx
f0100605:	c3                   	ret    
	else if (lflag)
f0100606:	85 d2                	test   %edx,%edx
f0100608:	74 0f                	je     f0100619 <getuint+0x25>
		return va_arg(*ap, unsigned long);
f010060a:	8b 10                	mov    (%eax),%edx
f010060c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010060f:	89 08                	mov    %ecx,(%eax)
f0100611:	8b 02                	mov    (%edx),%eax
f0100613:	ba 00 00 00 00       	mov    $0x0,%edx
f0100618:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
f0100619:	8b 10                	mov    (%eax),%edx
f010061b:	8d 4a 04             	lea    0x4(%edx),%ecx
f010061e:	89 08                	mov    %ecx,(%eax)
f0100620:	8b 02                	mov    (%edx),%eax
f0100622:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0100627:	c3                   	ret    

f0100628 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0100628:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
f010062c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0100630:	8b 10                	mov    (%eax),%edx
f0100632:	3b 50 04             	cmp    0x4(%eax),%edx
f0100635:	73 0b                	jae    f0100642 <sprintputch+0x1a>
		*b->buf++ = ch;
f0100637:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f010063b:	88 0a                	mov    %cl,(%edx)
f010063d:	83 c2 01             	add    $0x1,%edx
f0100640:	89 10                	mov    %edx,(%eax)
f0100642:	f3 c3                	repz ret 

f0100644 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0100644:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;

	va_start(ap, fmt);
f0100647:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010064b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010064f:	8b 44 24 28          	mov    0x28(%esp),%eax
f0100653:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100657:	8b 44 24 24          	mov    0x24(%esp),%eax
f010065b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010065f:	8b 44 24 20          	mov    0x20(%esp),%eax
f0100663:	89 04 24             	mov    %eax,(%esp)
f0100666:	e8 04 00 00 00       	call   f010066f <vprintfmt>
	va_end(ap);
}
f010066b:	83 c4 1c             	add    $0x1c,%esp
f010066e:	c3                   	ret    

f010066f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f010066f:	55                   	push   %ebp
f0100670:	57                   	push   %edi
f0100671:	56                   	push   %esi
f0100672:	53                   	push   %ebx
f0100673:	83 ec 4c             	sub    $0x4c,%esp
f0100676:	8b 6c 24 60          	mov    0x60(%esp),%ebp
f010067a:	8b 7c 24 64          	mov    0x64(%esp),%edi
f010067e:	8b 5c 24 68          	mov    0x68(%esp),%ebx
f0100682:	eb 11                	jmp    f0100695 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0100684:	85 c0                	test   %eax,%eax
f0100686:	0f 84 40 04 00 00    	je     f0100acc <vprintfmt+0x45d>
				return;
			putch(ch, putdat);
f010068c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100690:	89 04 24             	mov    %eax,(%esp)
f0100693:	ff d5                	call   *%ebp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0100695:	0f b6 03             	movzbl (%ebx),%eax
f0100698:	83 c3 01             	add    $0x1,%ebx
f010069b:	83 f8 25             	cmp    $0x25,%eax
f010069e:	75 e4                	jne    f0100684 <vprintfmt+0x15>
f01006a0:	c6 44 24 28 20       	movb   $0x20,0x28(%esp)
f01006a5:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
f01006ac:	00 
f01006ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01006b2:	c7 44 24 30 ff ff ff 	movl   $0xffffffff,0x30(%esp)
f01006b9:	ff 
f01006ba:	b9 00 00 00 00       	mov    $0x0,%ecx
f01006bf:	89 74 24 34          	mov    %esi,0x34(%esp)
f01006c3:	eb 34                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006c5:	8b 5c 24 24          	mov    0x24(%esp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
f01006c9:	c6 44 24 28 2d       	movb   $0x2d,0x28(%esp)
f01006ce:	eb 29                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006d0:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01006d4:	c6 44 24 28 30       	movb   $0x30,0x28(%esp)
f01006d9:	eb 1e                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006db:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
f01006df:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
f01006e6:	00 
f01006e7:	eb 10                	jmp    f01006f9 <vprintfmt+0x8a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f01006e9:	8b 44 24 34          	mov    0x34(%esp),%eax
f01006ed:	89 44 24 30          	mov    %eax,0x30(%esp)
f01006f1:	c7 44 24 34 ff ff ff 	movl   $0xffffffff,0x34(%esp)
f01006f8:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006f9:	0f b6 03             	movzbl (%ebx),%eax
f01006fc:	0f b6 d0             	movzbl %al,%edx
f01006ff:	8d 73 01             	lea    0x1(%ebx),%esi
f0100702:	89 74 24 24          	mov    %esi,0x24(%esp)
f0100706:	83 e8 23             	sub    $0x23,%eax
f0100709:	3c 55                	cmp    $0x55,%al
f010070b:	0f 87 9c 03 00 00    	ja     f0100aad <vprintfmt+0x43e>
f0100711:	0f b6 c0             	movzbl %al,%eax
f0100714:	ff 24 85 00 50 10 f0 	jmp    *-0xfefb000(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f010071b:	83 ea 30             	sub    $0x30,%edx
f010071e:	89 54 24 34          	mov    %edx,0x34(%esp)
				ch = *fmt;
f0100722:	8b 54 24 24          	mov    0x24(%esp),%edx
f0100726:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
f0100729:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010072c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
f0100730:	83 fa 09             	cmp    $0x9,%edx
f0100733:	77 5b                	ja     f0100790 <vprintfmt+0x121>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100735:	8b 74 24 34          	mov    0x34(%esp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0100739:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f010073c:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f010073f:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f0100743:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
f0100746:	8d 50 d0             	lea    -0x30(%eax),%edx
f0100749:	83 fa 09             	cmp    $0x9,%edx
f010074c:	76 eb                	jbe    f0100739 <vprintfmt+0xca>
f010074e:	89 74 24 34          	mov    %esi,0x34(%esp)
f0100752:	eb 3c                	jmp    f0100790 <vprintfmt+0x121>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0100754:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100758:	8d 50 04             	lea    0x4(%eax),%edx
f010075b:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010075f:	8b 00                	mov    (%eax),%eax
f0100761:	89 44 24 34          	mov    %eax,0x34(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100765:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0100769:	eb 25                	jmp    f0100790 <vprintfmt+0x121>

		case '.':
			if (width < 0)
f010076b:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100770:	0f 88 65 ff ff ff    	js     f01006db <vprintfmt+0x6c>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100776:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010077a:	e9 7a ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>
f010077f:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0100783:	c7 44 24 2c 01 00 00 	movl   $0x1,0x2c(%esp)
f010078a:	00 
			goto reswitch;
f010078b:	e9 69 ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>

		process_precision:
			if (width < 0)
f0100790:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100795:	0f 89 5e ff ff ff    	jns    f01006f9 <vprintfmt+0x8a>
f010079b:	e9 49 ff ff ff       	jmp    f01006e9 <vprintfmt+0x7a>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f01007a0:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01007a3:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f01007a7:	e9 4d ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f01007ac:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01007b0:	8d 50 04             	lea    0x4(%eax),%edx
f01007b3:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01007b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01007bb:	8b 00                	mov    (%eax),%eax
f01007bd:	89 04 24             	mov    %eax,(%esp)
f01007c0:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01007c2:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
f01007c6:	e9 ca fe ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
f01007cb:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01007cf:	8d 50 04             	lea    0x4(%eax),%edx
f01007d2:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01007d6:	8b 00                	mov    (%eax),%eax
f01007d8:	89 c2                	mov    %eax,%edx
f01007da:	c1 fa 1f             	sar    $0x1f,%edx
f01007dd:	31 d0                	xor    %edx,%eax
f01007df:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01007e1:	83 f8 08             	cmp    $0x8,%eax
f01007e4:	7f 0b                	jg     f01007f1 <vprintfmt+0x182>
f01007e6:	8b 14 85 60 51 10 f0 	mov    -0xfefaea0(,%eax,4),%edx
f01007ed:	85 d2                	test   %edx,%edx
f01007ef:	75 21                	jne    f0100812 <vprintfmt+0x1a3>
				printfmt(putch, putdat, "error %d", err);
f01007f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01007f5:	c7 44 24 08 a0 51 10 	movl   $0xf01051a0,0x8(%esp)
f01007fc:	f0 
f01007fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100801:	89 2c 24             	mov    %ebp,(%esp)
f0100804:	e8 3b fe ff ff       	call   f0100644 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100809:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
f010080d:	e9 83 fe ff ff       	jmp    f0100695 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
f0100812:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100816:	c7 44 24 08 3c 5b 10 	movl   $0xf0105b3c,0x8(%esp)
f010081d:	f0 
f010081e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100822:	89 2c 24             	mov    %ebp,(%esp)
f0100825:	e8 1a fe ff ff       	call   f0100644 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010082a:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010082e:	e9 62 fe ff ff       	jmp    f0100695 <vprintfmt+0x26>
f0100833:	8b 74 24 34          	mov    0x34(%esp),%esi
f0100837:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010083b:	8b 44 24 30          	mov    0x30(%esp),%eax
f010083f:	89 44 24 38          	mov    %eax,0x38(%esp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0100843:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100847:	8d 50 04             	lea    0x4(%eax),%edx
f010084a:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010084e:	8b 00                	mov    (%eax),%eax
				p = "(null)";
f0100850:	85 c0                	test   %eax,%eax
f0100852:	ba 99 51 10 f0       	mov    $0xf0105199,%edx
f0100857:	0f 45 d0             	cmovne %eax,%edx
f010085a:	89 54 24 34          	mov    %edx,0x34(%esp)
			if (width > 0 && padc != '-')
f010085e:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
f0100863:	7e 07                	jle    f010086c <vprintfmt+0x1fd>
f0100865:	80 7c 24 28 2d       	cmpb   $0x2d,0x28(%esp)
f010086a:	75 14                	jne    f0100880 <vprintfmt+0x211>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010086c:	8b 54 24 34          	mov    0x34(%esp),%edx
f0100870:	0f be 02             	movsbl (%edx),%eax
f0100873:	85 c0                	test   %eax,%eax
f0100875:	0f 85 ac 00 00 00    	jne    f0100927 <vprintfmt+0x2b8>
f010087b:	e9 97 00 00 00       	jmp    f0100917 <vprintfmt+0x2a8>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0100880:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100884:	8b 44 24 34          	mov    0x34(%esp),%eax
f0100888:	89 04 24             	mov    %eax,(%esp)
f010088b:	e8 89 f7 ff ff       	call   f0100019 <strnlen>
f0100890:	8b 54 24 38          	mov    0x38(%esp),%edx
f0100894:	29 c2                	sub    %eax,%edx
f0100896:	89 54 24 30          	mov    %edx,0x30(%esp)
f010089a:	85 d2                	test   %edx,%edx
f010089c:	7e ce                	jle    f010086c <vprintfmt+0x1fd>
					putch(padc, putdat);
f010089e:	0f be 44 24 28       	movsbl 0x28(%esp),%eax
f01008a3:	89 74 24 38          	mov    %esi,0x38(%esp)
f01008a7:	89 5c 24 3c          	mov    %ebx,0x3c(%esp)
f01008ab:	89 d3                	mov    %edx,%ebx
f01008ad:	89 c6                	mov    %eax,%esi
f01008af:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008b3:	89 34 24             	mov    %esi,(%esp)
f01008b6:	ff d5                	call   *%ebp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01008b8:	83 eb 01             	sub    $0x1,%ebx
f01008bb:	85 db                	test   %ebx,%ebx
f01008bd:	7f f0                	jg     f01008af <vprintfmt+0x240>
f01008bf:	8b 74 24 38          	mov    0x38(%esp),%esi
f01008c3:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
f01008c7:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
f01008ce:	00 
f01008cf:	eb 9b                	jmp    f010086c <vprintfmt+0x1fd>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01008d1:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
f01008d6:	74 19                	je     f01008f1 <vprintfmt+0x282>
f01008d8:	8d 50 e0             	lea    -0x20(%eax),%edx
f01008db:	83 fa 5e             	cmp    $0x5e,%edx
f01008de:	76 11                	jbe    f01008f1 <vprintfmt+0x282>
					putch('?', putdat);
f01008e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008e4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f01008eb:	ff 54 24 28          	call   *0x28(%esp)
f01008ef:	eb 0b                	jmp    f01008fc <vprintfmt+0x28d>
				else
					putch(ch, putdat);
f01008f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008f5:	89 04 24             	mov    %eax,(%esp)
f01008f8:	ff 54 24 28          	call   *0x28(%esp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01008fc:	83 ed 01             	sub    $0x1,%ebp
f01008ff:	0f be 03             	movsbl (%ebx),%eax
f0100902:	85 c0                	test   %eax,%eax
f0100904:	74 05                	je     f010090b <vprintfmt+0x29c>
f0100906:	83 c3 01             	add    $0x1,%ebx
f0100909:	eb 31                	jmp    f010093c <vprintfmt+0x2cd>
f010090b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
f010090f:	8b 6c 24 28          	mov    0x28(%esp),%ebp
f0100913:	8b 5c 24 38          	mov    0x38(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0100917:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f010091c:	7f 35                	jg     f0100953 <vprintfmt+0x2e4>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010091e:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f0100922:	e9 6e fd ff ff       	jmp    f0100695 <vprintfmt+0x26>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0100927:	8b 54 24 34          	mov    0x34(%esp),%edx
f010092b:	83 c2 01             	add    $0x1,%edx
f010092e:	89 6c 24 28          	mov    %ebp,0x28(%esp)
f0100932:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0100936:	89 5c 24 38          	mov    %ebx,0x38(%esp)
f010093a:	89 d3                	mov    %edx,%ebx
f010093c:	85 f6                	test   %esi,%esi
f010093e:	78 91                	js     f01008d1 <vprintfmt+0x262>
f0100940:	83 ee 01             	sub    $0x1,%esi
f0100943:	79 8c                	jns    f01008d1 <vprintfmt+0x262>
f0100945:	89 6c 24 30          	mov    %ebp,0x30(%esp)
f0100949:	8b 6c 24 28          	mov    0x28(%esp),%ebp
f010094d:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0100951:	eb c4                	jmp    f0100917 <vprintfmt+0x2a8>
f0100953:	89 de                	mov    %ebx,%esi
f0100955:	8b 5c 24 30          	mov    0x30(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0100959:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010095d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0100964:	ff d5                	call   *%ebp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0100966:	83 eb 01             	sub    $0x1,%ebx
f0100969:	85 db                	test   %ebx,%ebx
f010096b:	7f ec                	jg     f0100959 <vprintfmt+0x2ea>
f010096d:	89 f3                	mov    %esi,%ebx
f010096f:	e9 21 fd ff ff       	jmp    f0100695 <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0100974:	83 f9 01             	cmp    $0x1,%ecx
f0100977:	7e 12                	jle    f010098b <vprintfmt+0x31c>
		return va_arg(*ap, long long);
f0100979:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f010097d:	8d 50 08             	lea    0x8(%eax),%edx
f0100980:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f0100984:	8b 18                	mov    (%eax),%ebx
f0100986:	8b 70 04             	mov    0x4(%eax),%esi
f0100989:	eb 2a                	jmp    f01009b5 <vprintfmt+0x346>
	else if (lflag)
f010098b:	85 c9                	test   %ecx,%ecx
f010098d:	74 14                	je     f01009a3 <vprintfmt+0x334>
		return va_arg(*ap, long);
f010098f:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100993:	8d 50 04             	lea    0x4(%eax),%edx
f0100996:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010099a:	8b 18                	mov    (%eax),%ebx
f010099c:	89 de                	mov    %ebx,%esi
f010099e:	c1 fe 1f             	sar    $0x1f,%esi
f01009a1:	eb 12                	jmp    f01009b5 <vprintfmt+0x346>
	else
		return va_arg(*ap, int);
f01009a3:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01009a7:	8d 50 04             	lea    0x4(%eax),%edx
f01009aa:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01009ae:	8b 18                	mov    (%eax),%ebx
f01009b0:	89 de                	mov    %ebx,%esi
f01009b2:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f01009b5:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f01009ba:	85 f6                	test   %esi,%esi
f01009bc:	0f 89 ab 00 00 00    	jns    f0100a6d <vprintfmt+0x3fe>
				putch('-', putdat);
f01009c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01009c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01009cd:	ff d5                	call   *%ebp
				num = -(long long) num;
f01009cf:	f7 db                	neg    %ebx
f01009d1:	83 d6 00             	adc    $0x0,%esi
f01009d4:	f7 de                	neg    %esi
			}
			base = 10;
f01009d6:	b8 0a 00 00 00       	mov    $0xa,%eax
f01009db:	e9 8d 00 00 00       	jmp    f0100a6d <vprintfmt+0x3fe>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01009e0:	89 ca                	mov    %ecx,%edx
f01009e2:	8d 44 24 6c          	lea    0x6c(%esp),%eax
f01009e6:	e8 09 fc ff ff       	call   f01005f4 <getuint>
f01009eb:	89 c3                	mov    %eax,%ebx
f01009ed:	89 d6                	mov    %edx,%esi
			base = 10;
f01009ef:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
f01009f4:	eb 77                	jmp    f0100a6d <vprintfmt+0x3fe>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
f01009f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01009fa:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a01:	ff d5                	call   *%ebp
			putch('X', putdat);
f0100a03:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a07:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a0e:	ff d5                	call   *%ebp
			putch('X', putdat);
f0100a10:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a14:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a1b:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100a1d:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
f0100a21:	e9 6f fc ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// pointer
		case 'p':
			putch('0', putdat);
f0100a26:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a2a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0100a31:	ff d5                	call   *%ebp
			putch('x', putdat);
f0100a33:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a37:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0100a3e:	ff d5                	call   *%ebp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0100a40:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100a44:	8d 50 04             	lea    0x4(%eax),%edx
f0100a47:	89 54 24 6c          	mov    %edx,0x6c(%esp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0100a4b:	8b 18                	mov    (%eax),%ebx
f0100a4d:	be 00 00 00 00       	mov    $0x0,%esi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0100a52:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
f0100a57:	eb 14                	jmp    f0100a6d <vprintfmt+0x3fe>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0100a59:	89 ca                	mov    %ecx,%edx
f0100a5b:	8d 44 24 6c          	lea    0x6c(%esp),%eax
f0100a5f:	e8 90 fb ff ff       	call   f01005f4 <getuint>
f0100a64:	89 c3                	mov    %eax,%ebx
f0100a66:	89 d6                	mov    %edx,%esi
			base = 16;
f0100a68:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
f0100a6d:	0f be 54 24 28       	movsbl 0x28(%esp),%edx
f0100a72:	89 54 24 10          	mov    %edx,0x10(%esp)
f0100a76:	8b 54 24 30          	mov    0x30(%esp),%edx
f0100a7a:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100a7e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a82:	89 1c 24             	mov    %ebx,(%esp)
f0100a85:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100a89:	89 fa                	mov    %edi,%edx
f0100a8b:	89 e8                	mov    %ebp,%eax
f0100a8d:	e8 6e fa ff ff       	call   f0100500 <printnum>
			break;
f0100a92:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f0100a96:	e9 fa fb ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0100a9b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a9f:	89 14 24             	mov    %edx,(%esp)
f0100aa2:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100aa4:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
f0100aa8:	e9 e8 fb ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0100aad:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100ab1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0100ab8:	ff d5                	call   *%ebp
			for (fmt--; fmt[-1] != '%'; fmt--)
f0100aba:	eb 02                	jmp    f0100abe <vprintfmt+0x44f>
f0100abc:	89 c3                	mov    %eax,%ebx
f0100abe:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100ac1:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f0100ac5:	75 f5                	jne    f0100abc <vprintfmt+0x44d>
f0100ac7:	e9 c9 fb ff ff       	jmp    f0100695 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
f0100acc:	83 c4 4c             	add    $0x4c,%esp
f0100acf:	5b                   	pop    %ebx
f0100ad0:	5e                   	pop    %esi
f0100ad1:	5f                   	pop    %edi
f0100ad2:	5d                   	pop    %ebp
f0100ad3:	c3                   	ret    

f0100ad4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0100ad4:	83 ec 2c             	sub    $0x2c,%esp
f0100ad7:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100adb:	8b 54 24 34          	mov    0x34(%esp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0100adf:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100ae3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0100ae7:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f0100aeb:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
f0100af2:	00 

	if (buf == NULL || n < 1)
f0100af3:	85 c0                	test   %eax,%eax
f0100af5:	74 35                	je     f0100b2c <vsnprintf+0x58>
f0100af7:	85 d2                	test   %edx,%edx
f0100af9:	7e 31                	jle    f0100b2c <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0100afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0100aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b03:	8b 44 24 38          	mov    0x38(%esp),%eax
f0100b07:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b0b:	8d 44 24 14          	lea    0x14(%esp),%eax
f0100b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b13:	c7 04 24 28 06 10 f0 	movl   $0xf0100628,(%esp)
f0100b1a:	e8 50 fb ff ff       	call   f010066f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0100b1f:	8b 44 24 14          	mov    0x14(%esp),%eax
f0100b23:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0100b26:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f0100b2a:	eb 05                	jmp    f0100b31 <vsnprintf+0x5d>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0100b2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0100b31:	83 c4 2c             	add    $0x2c,%esp
f0100b34:	c3                   	ret    

f0100b35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0100b35:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0100b38:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0100b3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b40:	8b 44 24 28          	mov    0x28(%esp),%eax
f0100b44:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b48:	8b 44 24 24          	mov    0x24(%esp),%eax
f0100b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b50:	8b 44 24 20          	mov    0x20(%esp),%eax
f0100b54:	89 04 24             	mov    %eax,(%esp)
f0100b57:	e8 78 ff ff ff       	call   f0100ad4 <vsnprintf>
	va_end(ap);

	return rc;
}
f0100b5c:	83 c4 1c             	add    $0x1c,%esp
f0100b5f:	c3                   	ret    

f0100b60 <readline>:
f0100b60:	55                   	push   %ebp
f0100b61:	57                   	push   %edi
f0100b62:	56                   	push   %esi
f0100b63:	53                   	push   %ebx
f0100b64:	83 ec 1c             	sub    $0x1c,%esp
f0100b67:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100b6c:	74 14                	je     f0100b82 <readline+0x22>
f0100b6e:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100b72:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b76:	c7 04 24 3c 5b 10 f0 	movl   $0xf0105b3c,(%esp)
f0100b7d:	e8 55 f9 ff ff       	call   f01004d7 <cprintf>
f0100b82:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b87:	eb 0c                	jmp    f0100b95 <readline+0x35>
f0100b89:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b8e:	eb 05                	jmp    f0100b95 <readline+0x35>
f0100b90:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b95:	e8 5d 03 00 00       	call   f0100ef7 <getchar>
f0100b9a:	89 c6                	mov    %eax,%esi
f0100b9c:	83 3d 00 b0 10 f0 00 	cmpl   $0x0,0xf010b000
f0100ba3:	74 59                	je     f0100bfe <readline+0x9e>
f0100ba5:	83 3d 04 b0 10 f0 00 	cmpl   $0x0,0xf010b004
f0100bac:	74 50                	je     f0100bfe <readline+0x9e>
f0100bae:	83 f8 09             	cmp    $0x9,%eax
f0100bb1:	74 4b                	je     f0100bfe <readline+0x9e>
f0100bb3:	a1 08 b0 10 f0       	mov    0xf010b008,%eax
f0100bb8:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100bbb:	8b 04 85 00 70 10 f0 	mov    -0xfef9000(,%eax,4),%eax
f0100bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bc6:	c7 04 24 20 b0 10 f0 	movl   $0xf010b020,(%esp)
f0100bcd:	e8 6c f4 ff ff       	call   f010003e <strcpy>
f0100bd2:	c7 04 24 20 b0 10 f0 	movl   $0xf010b020,(%esp)
f0100bd9:	e8 22 f4 ff ff       	call   f0100000 <strlen>
f0100bde:	89 c3                	mov    %eax,%ebx
f0100be0:	c7 05 08 b0 10 f0 00 	movl   $0x0,0xf010b008
f0100be7:	00 00 00 
f0100bea:	c7 05 00 b0 10 f0 00 	movl   $0x0,0xf010b000
f0100bf1:	00 00 00 
f0100bf4:	c7 05 04 b0 10 f0 00 	movl   $0x0,0xf010b004
f0100bfb:	00 00 00 
f0100bfe:	85 f6                	test   %esi,%esi
f0100c00:	79 1a                	jns    f0100c1c <readline+0xbc>
f0100c02:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c06:	c7 04 24 3c 52 10 f0 	movl   $0xf010523c,(%esp)
f0100c0d:	e8 c5 f8 ff ff       	call   f01004d7 <cprintf>
f0100c12:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c17:	e9 af 02 00 00       	jmp    f0100ecb <readline+0x36b>
f0100c1c:	83 fe 08             	cmp    $0x8,%esi
f0100c1f:	74 05                	je     f0100c26 <readline+0xc6>
f0100c21:	83 fe 7f             	cmp    $0x7f,%esi
f0100c24:	75 18                	jne    f0100c3e <readline+0xde>
f0100c26:	85 db                	test   %ebx,%ebx
f0100c28:	7e 14                	jle    f0100c3e <readline+0xde>
f0100c2a:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100c31:	e8 a1 f8 ff ff       	call   f01004d7 <cprintf>
f0100c36:	83 eb 01             	sub    $0x1,%ebx
f0100c39:	e9 57 ff ff ff       	jmp    f0100b95 <readline+0x35>
f0100c3e:	8d 46 e0             	lea    -0x20(%esi),%eax
f0100c41:	83 f8 5e             	cmp    $0x5e,%eax
f0100c44:	77 28                	ja     f0100c6e <readline+0x10e>
f0100c46:	81 fb fe 03 00 00    	cmp    $0x3fe,%ebx
f0100c4c:	7f 20                	jg     f0100c6e <readline+0x10e>
f0100c4e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c52:	c7 04 24 4e 52 10 f0 	movl   $0xf010524e,(%esp)
f0100c59:	e8 79 f8 ff ff       	call   f01004d7 <cprintf>
f0100c5e:	89 f0                	mov    %esi,%eax
f0100c60:	88 83 20 b0 10 f0    	mov    %al,-0xfef4fe0(%ebx)
f0100c66:	83 c3 01             	add    $0x1,%ebx
f0100c69:	e9 27 ff ff ff       	jmp    f0100b95 <readline+0x35>
f0100c6e:	83 fe 0a             	cmp    $0xa,%esi
f0100c71:	74 05                	je     f0100c78 <readline+0x118>
f0100c73:	83 fe 0d             	cmp    $0xd,%esi
f0100c76:	75 1d                	jne    f0100c95 <readline+0x135>
f0100c78:	c7 04 24 06 58 10 f0 	movl   $0xf0105806,(%esp)
f0100c7f:	e8 53 f8 ff ff       	call   f01004d7 <cprintf>
f0100c84:	c6 83 20 b0 10 f0 00 	movb   $0x0,-0xfef4fe0(%ebx)
f0100c8b:	b8 20 b0 10 f0       	mov    $0xf010b020,%eax
f0100c90:	e9 36 02 00 00       	jmp    f0100ecb <readline+0x36b>
f0100c95:	83 fe 0c             	cmp    $0xc,%esi
f0100c98:	75 1e                	jne    f0100cb8 <readline+0x158>
f0100c9a:	e8 95 03 00 00       	call   f0101034 <cls>
f0100c9f:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ca7:	c7 04 24 3c 5b 10 f0 	movl   $0xf0105b3c,(%esp)
f0100cae:	e8 24 f8 ff ff       	call   f01004d7 <cprintf>
f0100cb3:	e9 dd fe ff ff       	jmp    f0100b95 <readline+0x35>
f0100cb8:	83 fe 09             	cmp    $0x9,%esi
f0100cbb:	0f 85 dd 00 00 00    	jne    f0100d9e <readline+0x23e>
f0100cc1:	bf 00 00 00 00       	mov    $0x0,%edi
f0100cc6:	83 3d 04 b0 10 f0 00 	cmpl   $0x0,0xf010b004
f0100ccd:	74 0f                	je     f0100cde <readline+0x17e>
f0100ccf:	8b 3d 08 b0 10 f0    	mov    0xf010b008,%edi
f0100cd5:	83 c7 01             	add    $0x1,%edi
f0100cd8:	66 be 00 00          	mov    $0x0,%si
f0100cdc:	eb 26                	jmp    f0100d04 <readline+0x1a4>
f0100cde:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100ce1:	8d 34 85 00 70 10 f0 	lea    -0xfef9000(,%eax,4),%esi
f0100ce8:	39 3d 84 51 10 f0    	cmp    %edi,0xf0105184
f0100cee:	7f 33                	jg     f0100d23 <readline+0x1c3>
f0100cf0:	e9 8e 00 00 00       	jmp    f0100d83 <readline+0x223>
f0100cf5:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100cfc:	e8 d6 f7 ff ff       	call   f01004d7 <cprintf>
f0100d01:	83 c6 01             	add    $0x1,%esi
f0100d04:	a1 08 b0 10 f0       	mov    0xf010b008,%eax
f0100d09:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100d0c:	8b 04 85 00 70 10 f0 	mov    -0xfef9000(,%eax,4),%eax
f0100d13:	89 04 24             	mov    %eax,(%esp)
f0100d16:	e8 e5 f2 ff ff       	call   f0100000 <strlen>
f0100d1b:	29 d8                	sub    %ebx,%eax
f0100d1d:	39 c6                	cmp    %eax,%esi
f0100d1f:	7c d4                	jl     f0100cf5 <readline+0x195>
f0100d21:	eb bb                	jmp    f0100cde <readline+0x17e>
f0100d23:	89 dd                	mov    %ebx,%ebp
f0100d25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100d29:	c7 44 24 04 20 b0 10 	movl   $0xf010b020,0x4(%esp)
f0100d30:	f0 
f0100d31:	8b 06                	mov    (%esi),%eax
f0100d33:	89 04 24             	mov    %eax,(%esp)
f0100d36:	e8 ec f3 ff ff       	call   f0100127 <strncmp>
f0100d3b:	85 c0                	test   %eax,%eax
f0100d3d:	75 36                	jne    f0100d75 <readline+0x215>
f0100d3f:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100d42:	03 2c 85 00 70 10 f0 	add    -0xfef9000(,%eax,4),%ebp
f0100d49:	89 6c 24 04          	mov    %ebp,0x4(%esp)
f0100d4d:	c7 04 24 3c 5b 10 f0 	movl   $0xf0105b3c,(%esp)
f0100d54:	e8 7e f7 ff ff       	call   f01004d7 <cprintf>
f0100d59:	c7 05 00 b0 10 f0 01 	movl   $0x1,0xf010b000
f0100d60:	00 00 00 
f0100d63:	c7 05 04 b0 10 f0 01 	movl   $0x1,0xf010b004
f0100d6a:	00 00 00 
f0100d6d:	89 3d 08 b0 10 f0    	mov    %edi,0xf010b008
f0100d73:	eb 0e                	jmp    f0100d83 <readline+0x223>
f0100d75:	83 c7 01             	add    $0x1,%edi
f0100d78:	83 c6 0c             	add    $0xc,%esi
f0100d7b:	39 3d 84 51 10 f0    	cmp    %edi,0xf0105184
f0100d81:	7f a0                	jg     f0100d23 <readline+0x1c3>
f0100d83:	3b 3d 84 51 10 f0    	cmp    0xf0105184,%edi
f0100d89:	0f 85 06 fe ff ff    	jne    f0100b95 <readline+0x35>
f0100d8f:	c7 05 04 b0 10 f0 00 	movl   $0x0,0xf010b004
f0100d96:	00 00 00 
f0100d99:	e9 f7 fd ff ff       	jmp    f0100b95 <readline+0x35>
f0100d9e:	83 fe 7f             	cmp    $0x7f,%esi
f0100da1:	0f 8e ee fd ff ff    	jle    f0100b95 <readline+0x35>
f0100da7:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
f0100dad:	74 11                	je     f0100dc0 <readline+0x260>
f0100daf:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
f0100db5:	0f 85 da fd ff ff    	jne    f0100b95 <readline+0x35>
f0100dbb:	e9 85 00 00 00       	jmp    f0100e45 <readline+0x2e5>
f0100dc0:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100dc5:	3b 05 a4 4e 11 f0    	cmp    0xf0114ea4,%eax
f0100dcb:	74 12                	je     f0100ddf <readline+0x27f>
f0100dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
f0100dd0:	85 c0                	test   %eax,%eax
f0100dd2:	b8 09 00 00 00       	mov    $0x9,%eax
f0100dd7:	0f 45 c2             	cmovne %edx,%eax
f0100dda:	a3 a0 4e 11 f0       	mov    %eax,0xf0114ea0
f0100ddf:	85 db                	test   %ebx,%ebx
f0100de1:	74 11                	je     f0100df4 <readline+0x294>
f0100de3:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100dea:	e8 e8 f6 ff ff       	call   f01004d7 <cprintf>
f0100def:	83 eb 01             	sub    $0x1,%ebx
f0100df2:	75 ef                	jne    f0100de3 <readline+0x283>
f0100df4:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100df9:	c1 e0 0a             	shl    $0xa,%eax
f0100dfc:	0f b6 80 c0 4e 11 f0 	movzbl -0xfeeb140(%eax),%eax
f0100e03:	84 c0                	test   %al,%al
f0100e05:	0f 84 7e fd ff ff    	je     f0100b89 <readline+0x29>
f0100e0b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100e10:	88 83 20 b0 10 f0    	mov    %al,-0xfef4fe0(%ebx)
f0100e16:	0f be c0             	movsbl %al,%eax
f0100e19:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e1d:	c7 04 24 4e 52 10 f0 	movl   $0xf010524e,(%esp)
f0100e24:	e8 ae f6 ff ff       	call   f01004d7 <cprintf>
f0100e29:	83 c3 01             	add    $0x1,%ebx
f0100e2c:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100e31:	c1 e0 0a             	shl    $0xa,%eax
f0100e34:	0f b6 84 03 c0 4e 11 	movzbl -0xfeeb140(%ebx,%eax,1),%eax
f0100e3b:	f0 
f0100e3c:	84 c0                	test   %al,%al
f0100e3e:	75 d0                	jne    f0100e10 <readline+0x2b0>
f0100e40:	e9 50 fd ff ff       	jmp    f0100b95 <readline+0x35>
f0100e45:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100e4a:	3b 05 a8 4e 11 f0    	cmp    0xf0114ea8,%eax
f0100e50:	74 13                	je     f0100e65 <readline+0x305>
f0100e52:	8d 50 01             	lea    0x1(%eax),%edx
f0100e55:	83 f8 09             	cmp    $0x9,%eax
f0100e58:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e5d:	0f 45 c2             	cmovne %edx,%eax
f0100e60:	a3 a0 4e 11 f0       	mov    %eax,0xf0114ea0
f0100e65:	85 db                	test   %ebx,%ebx
f0100e67:	74 11                	je     f0100e7a <readline+0x31a>
f0100e69:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100e70:	e8 62 f6 ff ff       	call   f01004d7 <cprintf>
f0100e75:	83 eb 01             	sub    $0x1,%ebx
f0100e78:	75 ef                	jne    f0100e69 <readline+0x309>
f0100e7a:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100e7f:	c1 e0 0a             	shl    $0xa,%eax
f0100e82:	0f b6 80 c0 4e 11 f0 	movzbl -0xfeeb140(%eax),%eax
f0100e89:	84 c0                	test   %al,%al
f0100e8b:	0f 84 ff fc ff ff    	je     f0100b90 <readline+0x30>
f0100e91:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100e96:	88 83 20 b0 10 f0    	mov    %al,-0xfef4fe0(%ebx)
f0100e9c:	0f be c0             	movsbl %al,%eax
f0100e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ea3:	c7 04 24 4e 52 10 f0 	movl   $0xf010524e,(%esp)
f0100eaa:	e8 28 f6 ff ff       	call   f01004d7 <cprintf>
f0100eaf:	83 c3 01             	add    $0x1,%ebx
f0100eb2:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100eb7:	c1 e0 0a             	shl    $0xa,%eax
f0100eba:	0f b6 84 03 c0 4e 11 	movzbl -0xfeeb140(%ebx,%eax,1),%eax
f0100ec1:	f0 
f0100ec2:	84 c0                	test   %al,%al
f0100ec4:	75 d0                	jne    f0100e96 <readline+0x336>
f0100ec6:	e9 ca fc ff ff       	jmp    f0100b95 <readline+0x35>
f0100ecb:	83 c4 1c             	add    $0x1c,%esp
f0100ece:	5b                   	pop    %ebx
f0100ecf:	5e                   	pop    %esi
f0100ed0:	5f                   	pop    %edi
f0100ed1:	5d                   	pop    %ebp
f0100ed2:	c3                   	ret    
	...

f0100ed4 <cputchar>:
f0100ed4:	83 ec 2c             	sub    $0x2c,%esp
f0100ed7:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100edb:	88 44 24 1f          	mov    %al,0x1f(%esp)
f0100edf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0100ee6:	00 
f0100ee7:	8d 44 24 1f          	lea    0x1f(%esp),%eax
f0100eeb:	89 04 24             	mov    %eax,(%esp)
f0100eee:	e8 46 00 00 00       	call   f0100f39 <puts>
f0100ef3:	83 c4 2c             	add    $0x2c,%esp
f0100ef6:	c3                   	ret    

f0100ef7 <getchar>:
f0100ef7:	83 ec 0c             	sub    $0xc,%esp
f0100efa:	e8 09 00 00 00       	call   f0100f08 <getc>
f0100eff:	85 c0                	test   %eax,%eax
f0100f01:	74 f7                	je     f0100efa <getchar+0x3>
f0100f03:	83 c4 0c             	add    $0xc,%esp
f0100f06:	c3                   	ret    
	...

f0100f08 <getc>:

	return ret;
}


SYSCALL_NOARG(getc, int)
f0100f08:	83 ec 0c             	sub    $0xc,%esp
f0100f0b:	89 1c 24             	mov    %ebx,(%esp)
f0100f0e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f12:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f16:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f1b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100f20:	89 d1                	mov    %edx,%ecx
f0100f22:	89 d3                	mov    %edx,%ebx
f0100f24:	89 d7                	mov    %edx,%edi
f0100f26:	89 d6                	mov    %edx,%esi
f0100f28:	cd 30                	int    $0x30

	return ret;
}


SYSCALL_NOARG(getc, int)
f0100f2a:	8b 1c 24             	mov    (%esp),%ebx
f0100f2d:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f31:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f35:	83 c4 0c             	add    $0xc,%esp
f0100f38:	c3                   	ret    

f0100f39 <puts>:

void
puts(const char *s, size_t len)
{
f0100f39:	83 ec 0c             	sub    $0xc,%esp
f0100f3c:	89 1c 24             	mov    %ebx,(%esp)
f0100f3f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f43:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f47:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f4c:	8b 4c 24 14          	mov    0x14(%esp),%ecx
f0100f50:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100f54:	89 c3                	mov    %eax,%ebx
f0100f56:	89 c7                	mov    %eax,%edi
f0100f58:	89 c6                	mov    %eax,%esi
f0100f5a:	cd 30                	int    $0x30

void
puts(const char *s, size_t len)
{
	syscall(SYS_puts,(uint32_t)s, len, 0, 0, 0);
}
f0100f5c:	8b 1c 24             	mov    (%esp),%ebx
f0100f5f:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f63:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f67:	83 c4 0c             	add    $0xc,%esp
f0100f6a:	c3                   	ret    

f0100f6b <get_ticks>:
 * function of the shell
 *
 * HINT: You can use SYSCALL_NOARG to save your time.
 */

unsigned long get_ticks(void){
f0100f6b:	83 ec 0c             	sub    $0xc,%esp
f0100f6e:	89 1c 24             	mov    %ebx,(%esp)
f0100f71:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f75:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f79:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f7e:	b8 08 00 00 00       	mov    $0x8,%eax
f0100f83:	89 d1                	mov    %edx,%ecx
f0100f85:	89 d3                	mov    %edx,%ebx
f0100f87:	89 d7                	mov    %edx,%edi
f0100f89:	89 d6                	mov    %edx,%esi
f0100f8b:	cd 30                	int    $0x30

unsigned long get_ticks(void){

	syscall(SYS_get_ticks, 0,0,0,0,0);

}
f0100f8d:	8b 1c 24             	mov    (%esp),%ebx
f0100f90:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f94:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f98:	83 c4 0c             	add    $0xc,%esp
f0100f9b:	c3                   	ret    

f0100f9c <fork>:
	syscall(SYS_kill,getpid(),0,0,0,0);
}


//SYSCALL_NOARG(kill, int)
SYSCALL_NOARG(fork, int)
f0100f9c:	83 ec 0c             	sub    $0xc,%esp
f0100f9f:	89 1c 24             	mov    %ebx,(%esp)
f0100fa2:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fa6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100faa:	ba 00 00 00 00       	mov    $0x0,%edx
f0100faf:	b8 03 00 00 00       	mov    $0x3,%eax
f0100fb4:	89 d1                	mov    %edx,%ecx
f0100fb6:	89 d3                	mov    %edx,%ebx
f0100fb8:	89 d7                	mov    %edx,%edi
f0100fba:	89 d6                	mov    %edx,%esi
f0100fbc:	cd 30                	int    $0x30
	syscall(SYS_kill,getpid(),0,0,0,0);
}


//SYSCALL_NOARG(kill, int)
SYSCALL_NOARG(fork, int)
f0100fbe:	8b 1c 24             	mov    (%esp),%ebx
f0100fc1:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100fc5:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100fc9:	83 c4 0c             	add    $0xc,%esp
f0100fcc:	c3                   	ret    

f0100fcd <getpid>:
SYSCALL_NOARG(getpid, int)
f0100fcd:	83 ec 0c             	sub    $0xc,%esp
f0100fd0:	89 1c 24             	mov    %ebx,(%esp)
f0100fd3:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fd7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100fdb:	ba 00 00 00 00       	mov    $0x0,%edx
f0100fe0:	b8 02 00 00 00       	mov    $0x2,%eax
f0100fe5:	89 d1                	mov    %edx,%ecx
f0100fe7:	89 d3                	mov    %edx,%ebx
f0100fe9:	89 d7                	mov    %edx,%edi
f0100feb:	89 d6                	mov    %edx,%esi
f0100fed:	cd 30                	int    $0x30
}


//SYSCALL_NOARG(kill, int)
SYSCALL_NOARG(fork, int)
SYSCALL_NOARG(getpid, int)
f0100fef:	8b 1c 24             	mov    (%esp),%ebx
f0100ff2:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100ff6:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100ffa:	83 c4 0c             	add    $0xc,%esp
f0100ffd:	c3                   	ret    

f0100ffe <kill_self>:
unsigned long get_ticks(void){

	syscall(SYS_get_ticks, 0,0,0,0,0);

}
void kill_self(){
f0100ffe:	83 ec 0c             	sub    $0xc,%esp
f0101001:	89 1c 24             	mov    %ebx,(%esp)
f0101004:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101008:	89 7c 24 08          	mov    %edi,0x8(%esp)
	syscall(SYS_kill,getpid(),0,0,0,0);
f010100c:	e8 bc ff ff ff       	call   f0100fcd <getpid>
f0101011:	89 c2                	mov    %eax,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0101013:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101018:	b8 04 00 00 00       	mov    $0x4,%eax
f010101d:	89 cb                	mov    %ecx,%ebx
f010101f:	89 cf                	mov    %ecx,%edi
f0101021:	89 ce                	mov    %ecx,%esi
f0101023:	cd 30                	int    $0x30
	syscall(SYS_get_ticks, 0,0,0,0,0);

}
void kill_self(){
	syscall(SYS_kill,getpid(),0,0,0,0);
}
f0101025:	8b 1c 24             	mov    (%esp),%ebx
f0101028:	8b 74 24 04          	mov    0x4(%esp),%esi
f010102c:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101030:	83 c4 0c             	add    $0xc,%esp
f0101033:	c3                   	ret    

f0101034 <cls>:


//SYSCALL_NOARG(kill, int)
SYSCALL_NOARG(fork, int)
SYSCALL_NOARG(getpid, int)
SYSCALL_NOARG(cls, int)
f0101034:	83 ec 0c             	sub    $0xc,%esp
f0101037:	89 1c 24             	mov    %ebx,(%esp)
f010103a:	89 74 24 04          	mov    %esi,0x4(%esp)
f010103e:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0101042:	ba 00 00 00 00       	mov    $0x0,%edx
f0101047:	b8 0a 00 00 00       	mov    $0xa,%eax
f010104c:	89 d1                	mov    %edx,%ecx
f010104e:	89 d3                	mov    %edx,%ebx
f0101050:	89 d7                	mov    %edx,%edi
f0101052:	89 d6                	mov    %edx,%esi
f0101054:	cd 30                	int    $0x30


//SYSCALL_NOARG(kill, int)
SYSCALL_NOARG(fork, int)
SYSCALL_NOARG(getpid, int)
SYSCALL_NOARG(cls, int)
f0101056:	8b 1c 24             	mov    (%esp),%ebx
f0101059:	8b 74 24 04          	mov    0x4(%esp),%esi
f010105d:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101061:	83 c4 0c             	add    $0xc,%esp
f0101064:	c3                   	ret    

f0101065 <get_num_free_page>:
//SYSCALL_NOARG(get_ticks, int)
SYSCALL_NOARG(get_num_free_page, int)
f0101065:	83 ec 0c             	sub    $0xc,%esp
f0101068:	89 1c 24             	mov    %ebx,(%esp)
f010106b:	89 74 24 04          	mov    %esi,0x4(%esp)
f010106f:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0101073:	ba 00 00 00 00       	mov    $0x0,%edx
f0101078:	b8 07 00 00 00       	mov    $0x7,%eax
f010107d:	89 d1                	mov    %edx,%ecx
f010107f:	89 d3                	mov    %edx,%ebx
f0101081:	89 d7                	mov    %edx,%edi
f0101083:	89 d6                	mov    %edx,%esi
f0101085:	cd 30                	int    $0x30
//SYSCALL_NOARG(kill, int)
SYSCALL_NOARG(fork, int)
SYSCALL_NOARG(getpid, int)
SYSCALL_NOARG(cls, int)
//SYSCALL_NOARG(get_ticks, int)
SYSCALL_NOARG(get_num_free_page, int)
f0101087:	8b 1c 24             	mov    (%esp),%ebx
f010108a:	8b 74 24 04          	mov    0x4(%esp),%esi
f010108e:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101092:	83 c4 0c             	add    $0xc,%esp
f0101095:	c3                   	ret    

f0101096 <get_num_used_page>:
SYSCALL_NOARG(get_num_used_page, int)
f0101096:	83 ec 0c             	sub    $0xc,%esp
f0101099:	89 1c 24             	mov    %ebx,(%esp)
f010109c:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010a0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f01010a4:	ba 00 00 00 00       	mov    $0x0,%edx
f01010a9:	b8 06 00 00 00       	mov    $0x6,%eax
f01010ae:	89 d1                	mov    %edx,%ecx
f01010b0:	89 d3                	mov    %edx,%ebx
f01010b2:	89 d7                	mov    %edx,%edi
f01010b4:	89 d6                	mov    %edx,%esi
f01010b6:	cd 30                	int    $0x30
SYSCALL_NOARG(fork, int)
SYSCALL_NOARG(getpid, int)
SYSCALL_NOARG(cls, int)
//SYSCALL_NOARG(get_ticks, int)
SYSCALL_NOARG(get_num_free_page, int)
SYSCALL_NOARG(get_num_used_page, int)
f01010b8:	8b 1c 24             	mov    (%esp),%ebx
f01010bb:	8b 74 24 04          	mov    0x4(%esp),%esi
f01010bf:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01010c3:	83 c4 0c             	add    $0xc,%esp
f01010c6:	c3                   	ret    

f01010c7 <sleep>:
void sleep(uint32_t ticks){
f01010c7:	83 ec 0c             	sub    $0xc,%esp
f01010ca:	89 1c 24             	mov    %ebx,(%esp)
f01010cd:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010d1:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f01010d5:	b9 00 00 00 00       	mov    $0x0,%ecx
f01010da:	b8 05 00 00 00       	mov    $0x5,%eax
f01010df:	8b 54 24 10          	mov    0x10(%esp),%edx
f01010e3:	89 cb                	mov    %ecx,%ebx
f01010e5:	89 cf                	mov    %ecx,%edi
f01010e7:	89 ce                	mov    %ecx,%esi
f01010e9:	cd 30                	int    $0x30
//SYSCALL_NOARG(get_ticks, int)
SYSCALL_NOARG(get_num_free_page, int)
SYSCALL_NOARG(get_num_used_page, int)
void sleep(uint32_t ticks){
	syscall(SYS_sleep, ticks,0,0,0,0);
} 
f01010eb:	8b 1c 24             	mov    (%esp),%ebx
f01010ee:	8b 74 24 04          	mov    0x4(%esp),%esi
f01010f2:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01010f6:	83 c4 0c             	add    $0xc,%esp
f01010f9:	c3                   	ret    

f01010fa <settextcolor>:
void settextcolor(unsigned char forecolor, unsigned char backcolor)
{
f01010fa:	83 ec 0c             	sub    $0xc,%esp
f01010fd:	89 1c 24             	mov    %ebx,(%esp)
f0101100:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101104:	89 7c 24 08          	mov    %edi,0x8(%esp)
	syscall(SYS_settextcolor, (uint32_t)forecolor, (uint32_t)backcolor,0,0,0);
f0101108:	0f b6 54 24 10       	movzbl 0x10(%esp),%edx
f010110d:	0f b6 4c 24 14       	movzbl 0x14(%esp),%ecx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0101112:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101117:	b8 09 00 00 00       	mov    $0x9,%eax
f010111c:	89 df                	mov    %ebx,%edi
f010111e:	89 de                	mov    %ebx,%esi
f0101120:	cd 30                	int    $0x30
	syscall(SYS_sleep, ticks,0,0,0,0);
} 
void settextcolor(unsigned char forecolor, unsigned char backcolor)
{
	syscall(SYS_settextcolor, (uint32_t)forecolor, (uint32_t)backcolor,0,0,0);
}
f0101122:	8b 1c 24             	mov    (%esp),%ebx
f0101125:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101129:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010112d:	83 c4 0c             	add    $0xc,%esp
f0101130:	c3                   	ret    
	...

f0101140 <mon_help>:
f0101140:	53                   	push   %ebx
f0101141:	83 ec 18             	sub    $0x18,%esp
f0101144:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101149:	8b 83 04 70 10 f0    	mov    -0xfef8ffc(%ebx),%eax
f010114f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101153:	8b 83 00 70 10 f0    	mov    -0xfef9000(%ebx),%eax
f0101159:	89 44 24 04          	mov    %eax,0x4(%esp)
f010115d:	c7 04 24 51 52 10 f0 	movl   $0xf0105251,(%esp)
f0101164:	e8 6e f3 ff ff       	call   f01004d7 <cprintf>
f0101169:	83 c3 0c             	add    $0xc,%ebx
f010116c:	83 fb 3c             	cmp    $0x3c,%ebx
f010116f:	75 d8                	jne    f0101149 <mon_help+0x9>
f0101171:	b8 00 00 00 00       	mov    $0x0,%eax
f0101176:	83 c4 18             	add    $0x18,%esp
f0101179:	5b                   	pop    %ebx
f010117a:	c3                   	ret    

f010117b <chgcolor>:
f010117b:	53                   	push   %ebx
f010117c:	83 ec 18             	sub    $0x18,%esp
f010117f:	83 7c 24 20 01       	cmpl   $0x1,0x20(%esp)
f0101184:	7e 35                	jle    f01011bb <chgcolor+0x40>
f0101186:	8b 44 24 24          	mov    0x24(%esp),%eax
f010118a:	8b 40 04             	mov    0x4(%eax),%eax
f010118d:	0f b6 18             	movzbl (%eax),%ebx
f0101190:	83 eb 30             	sub    $0x30,%ebx
f0101193:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010119a:	00 
f010119b:	0f b6 c3             	movzbl %bl,%eax
f010119e:	89 04 24             	mov    %eax,(%esp)
f01011a1:	e8 54 ff ff ff       	call   f01010fa <settextcolor>
f01011a6:	0f be db             	movsbl %bl,%ebx
f01011a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01011ad:	c7 04 24 5a 52 10 f0 	movl   $0xf010525a,(%esp)
f01011b4:	e8 1e f3 ff ff       	call   f01004d7 <cprintf>
f01011b9:	eb 0c                	jmp    f01011c7 <chgcolor+0x4c>
f01011bb:	c7 04 24 6c 52 10 f0 	movl   $0xf010526c,(%esp)
f01011c2:	e8 10 f3 ff ff       	call   f01004d7 <cprintf>
f01011c7:	b8 00 00 00 00       	mov    $0x0,%eax
f01011cc:	83 c4 18             	add    $0x18,%esp
f01011cf:	5b                   	pop    %ebx
f01011d0:	c3                   	ret    

f01011d1 <print_tick>:
f01011d1:	83 ec 1c             	sub    $0x1c,%esp
f01011d4:	e8 92 fd ff ff       	call   f0100f6b <get_ticks>
f01011d9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01011dd:	c7 04 24 82 52 10 f0 	movl   $0xf0105282,(%esp)
f01011e4:	e8 ee f2 ff ff       	call   f01004d7 <cprintf>
f01011e9:	b8 00 00 00 00       	mov    $0x0,%eax
f01011ee:	83 c4 1c             	add    $0x1c,%esp
f01011f1:	c3                   	ret    

f01011f2 <mem_stat>:
f01011f2:	83 ec 1c             	sub    $0x1c,%esp
f01011f5:	c7 44 24 08 91 52 10 	movl   $0xf0105291,0x8(%esp)
f01011fc:	f0 
f01011fd:	c7 44 24 04 91 52 10 	movl   $0xf0105291,0x4(%esp)
f0101204:	f0 
f0101205:	c7 04 24 9a 52 10 f0 	movl   $0xf010529a,(%esp)
f010120c:	e8 c6 f2 ff ff       	call   f01004d7 <cprintf>
f0101211:	e8 80 fe ff ff       	call   f0101096 <get_num_used_page>
f0101216:	89 44 24 04          	mov    %eax,0x4(%esp)
f010121a:	c7 04 24 af 52 10 f0 	movl   $0xf01052af,(%esp)
f0101221:	e8 b1 f2 ff ff       	call   f01004d7 <cprintf>
f0101226:	e8 3a fe ff ff       	call   f0101065 <get_num_free_page>
f010122b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010122f:	c7 04 24 c1 52 10 f0 	movl   $0xf01052c1,(%esp)
f0101236:	e8 9c f2 ff ff       	call   f01004d7 <cprintf>
f010123b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101240:	83 c4 1c             	add    $0x1c,%esp
f0101243:	c3                   	ret    

f0101244 <task_job>:
f0101244:	56                   	push   %esi
f0101245:	53                   	push   %ebx
f0101246:	83 ec 14             	sub    $0x14,%esp
f0101249:	e8 7f fd ff ff       	call   f0100fcd <getpid>
f010124e:	89 c6                	mov    %eax,%esi
f0101250:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101255:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0101259:	89 74 24 04          	mov    %esi,0x4(%esp)
f010125d:	c7 04 24 d3 52 10 f0 	movl   $0xf01052d3,(%esp)
f0101264:	e8 6e f2 ff ff       	call   f01004d7 <cprintf>
f0101269:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0101270:	e8 52 fe ff ff       	call   f01010c7 <sleep>
f0101275:	83 c3 01             	add    $0x1,%ebx
f0101278:	83 fb 0a             	cmp    $0xa,%ebx
f010127b:	75 d8                	jne    f0101255 <task_job+0x11>
f010127d:	83 c4 14             	add    $0x14,%esp
f0101280:	5b                   	pop    %ebx
f0101281:	5e                   	pop    %esi
f0101282:	c3                   	ret    

f0101283 <forktest>:
f0101283:	83 ec 0c             	sub    $0xc,%esp
f0101286:	e8 11 fd ff ff       	call   f0100f9c <fork>
f010128b:	85 c0                	test   %eax,%eax
f010128d:	75 48                	jne    f01012d7 <forktest+0x54>
f010128f:	e8 b0 ff ff ff       	call   f0101244 <task_job>
f0101294:	e8 03 fd ff ff       	call   f0100f9c <fork>
f0101299:	85 c0                	test   %eax,%eax
f010129b:	74 0a                	je     f01012a7 <forktest+0x24>
f010129d:	8d 76 00             	lea    0x0(%esi),%esi
f01012a0:	e8 9f ff ff ff       	call   f0101244 <task_job>
f01012a5:	eb 30                	jmp    f01012d7 <forktest+0x54>
f01012a7:	e8 f0 fc ff ff       	call   f0100f9c <fork>
f01012ac:	85 c0                	test   %eax,%eax
f01012ae:	66 90                	xchg   %ax,%ax
f01012b0:	74 07                	je     f01012b9 <forktest+0x36>
f01012b2:	e8 8d ff ff ff       	call   f0101244 <task_job>
f01012b7:	eb 1e                	jmp    f01012d7 <forktest+0x54>
f01012b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01012c0:	e8 d7 fc ff ff       	call   f0100f9c <fork>
f01012c5:	85 c0                	test   %eax,%eax
f01012c7:	74 09                	je     f01012d2 <forktest+0x4f>
f01012c9:	e8 76 ff ff ff       	call   f0101244 <task_job>
f01012ce:	66 90                	xchg   %ax,%ax
f01012d0:	eb 05                	jmp    f01012d7 <forktest+0x54>
f01012d2:	e8 6d ff ff ff       	call   f0101244 <task_job>
f01012d7:	e8 22 fd ff ff       	call   f0100ffe <kill_self>
f01012dc:	b8 00 00 00 00       	mov    $0x0,%eax
f01012e1:	83 c4 0c             	add    $0xc,%esp
f01012e4:	c3                   	ret    

f01012e5 <shell>:
f01012e5:	55                   	push   %ebp
f01012e6:	57                   	push   %edi
f01012e7:	56                   	push   %esi
f01012e8:	53                   	push   %ebx
f01012e9:	83 ec 5c             	sub    $0x5c,%esp
f01012ec:	c7 05 a4 4e 11 f0 00 	movl   $0x0,0xf0114ea4
f01012f3:	00 00 00 
f01012f6:	c7 05 a8 4e 11 f0 00 	movl   $0x0,0xf0114ea8
f01012fd:	00 00 00 
f0101300:	c7 05 a0 4e 11 f0 00 	movl   $0x0,0xf0114ea0
f0101307:	00 00 00 
f010130a:	c7 04 24 e2 52 10 f0 	movl   $0xf01052e2,(%esp)
f0101311:	e8 c1 f1 ff ff       	call   f01004d7 <cprintf>
f0101316:	c7 04 24 d4 53 10 f0 	movl   $0xf01053d4,(%esp)
f010131d:	e8 b5 f1 ff ff       	call   f01004d7 <cprintf>
f0101322:	bd 67 66 66 66       	mov    $0x66666667,%ebp
f0101327:	c7 04 24 ff 52 10 f0 	movl   $0xf01052ff,(%esp)
f010132e:	e8 2d f8 ff ff       	call   f0100b60 <readline>
f0101333:	89 c3                	mov    %eax,%ebx
f0101335:	85 c0                	test   %eax,%eax
f0101337:	74 ee                	je     f0101327 <shell+0x42>
f0101339:	89 44 24 04          	mov    %eax,0x4(%esp)
f010133d:	a1 a8 4e 11 f0       	mov    0xf0114ea8,%eax
f0101342:	c1 e0 0a             	shl    $0xa,%eax
f0101345:	05 c0 4e 11 f0       	add    $0xf0114ec0,%eax
f010134a:	89 04 24             	mov    %eax,(%esp)
f010134d:	e8 ec ec ff ff       	call   f010003e <strcpy>
f0101352:	8b 35 a8 4e 11 f0    	mov    0xf0114ea8,%esi
f0101358:	83 c6 01             	add    $0x1,%esi
f010135b:	89 f0                	mov    %esi,%eax
f010135d:	f7 ed                	imul   %ebp
f010135f:	89 d1                	mov    %edx,%ecx
f0101361:	c1 f9 02             	sar    $0x2,%ecx
f0101364:	89 f0                	mov    %esi,%eax
f0101366:	c1 f8 1f             	sar    $0x1f,%eax
f0101369:	29 c1                	sub    %eax,%ecx
f010136b:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f010136e:	01 c0                	add    %eax,%eax
f0101370:	89 f1                	mov    %esi,%ecx
f0101372:	29 c1                	sub    %eax,%ecx
f0101374:	89 0d a8 4e 11 f0    	mov    %ecx,0xf0114ea8
f010137a:	3b 0d a4 4e 11 f0    	cmp    0xf0114ea4,%ecx
f0101380:	75 2a                	jne    f01013ac <shell+0xc7>
f0101382:	8d 71 01             	lea    0x1(%ecx),%esi
f0101385:	89 f0                	mov    %esi,%eax
f0101387:	f7 ed                	imul   %ebp
f0101389:	c1 fa 02             	sar    $0x2,%edx
f010138c:	89 f0                	mov    %esi,%eax
f010138e:	c1 f8 1f             	sar    $0x1f,%eax
f0101391:	29 c2                	sub    %eax,%edx
f0101393:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101396:	01 c0                	add    %eax,%eax
f0101398:	29 c6                	sub    %eax,%esi
f010139a:	89 35 a4 4e 11 f0    	mov    %esi,0xf0114ea4
f01013a0:	89 c8                	mov    %ecx,%eax
f01013a2:	c1 e0 0a             	shl    $0xa,%eax
f01013a5:	c6 80 c0 4e 11 f0 00 	movb   $0x0,-0xfeeb140(%eax)
f01013ac:	89 0d a0 4e 11 f0    	mov    %ecx,0xf0114ea0
f01013b2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
f01013b9:	00 
f01013ba:	be 00 00 00 00       	mov    $0x0,%esi
f01013bf:	eb 06                	jmp    f01013c7 <shell+0xe2>
f01013c1:	c6 03 00             	movb   $0x0,(%ebx)
f01013c4:	83 c3 01             	add    $0x1,%ebx
f01013c7:	0f b6 03             	movzbl (%ebx),%eax
f01013ca:	84 c0                	test   %al,%al
f01013cc:	74 70                	je     f010143e <shell+0x159>
f01013ce:	0f be c0             	movsbl %al,%eax
f01013d1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01013d5:	c7 04 24 06 53 10 f0 	movl   $0xf0105306,(%esp)
f01013dc:	e8 90 ed ff ff       	call   f0100171 <strchr>
f01013e1:	85 c0                	test   %eax,%eax
f01013e3:	75 dc                	jne    f01013c1 <shell+0xdc>
f01013e5:	80 3b 00             	cmpb   $0x0,(%ebx)
f01013e8:	74 54                	je     f010143e <shell+0x159>
f01013ea:	83 fe 0f             	cmp    $0xf,%esi
f01013ed:	8d 76 00             	lea    0x0(%esi),%esi
f01013f0:	75 19                	jne    f010140b <shell+0x126>
f01013f2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f01013f9:	00 
f01013fa:	c7 04 24 0b 53 10 f0 	movl   $0xf010530b,(%esp)
f0101401:	e8 d1 f0 ff ff       	call   f01004d7 <cprintf>
f0101406:	e9 1c ff ff ff       	jmp    f0101327 <shell+0x42>
f010140b:	89 5c b4 10          	mov    %ebx,0x10(%esp,%esi,4)
f010140f:	83 c6 01             	add    $0x1,%esi
f0101412:	0f b6 03             	movzbl (%ebx),%eax
f0101415:	84 c0                	test   %al,%al
f0101417:	75 0c                	jne    f0101425 <shell+0x140>
f0101419:	eb ac                	jmp    f01013c7 <shell+0xe2>
f010141b:	83 c3 01             	add    $0x1,%ebx
f010141e:	0f b6 03             	movzbl (%ebx),%eax
f0101421:	84 c0                	test   %al,%al
f0101423:	74 a2                	je     f01013c7 <shell+0xe2>
f0101425:	0f be c0             	movsbl %al,%eax
f0101428:	89 44 24 04          	mov    %eax,0x4(%esp)
f010142c:	c7 04 24 06 53 10 f0 	movl   $0xf0105306,(%esp)
f0101433:	e8 39 ed ff ff       	call   f0100171 <strchr>
f0101438:	85 c0                	test   %eax,%eax
f010143a:	74 df                	je     f010141b <shell+0x136>
f010143c:	eb 89                	jmp    f01013c7 <shell+0xe2>
f010143e:	c7 44 b4 10 00 00 00 	movl   $0x0,0x10(%esp,%esi,4)
f0101445:	00 
f0101446:	85 f6                	test   %esi,%esi
f0101448:	0f 84 d9 fe ff ff    	je     f0101327 <shell+0x42>
f010144e:	bb 00 70 10 f0       	mov    $0xf0107000,%ebx
f0101453:	bf 00 00 00 00       	mov    $0x0,%edi
f0101458:	8b 03                	mov    (%ebx),%eax
f010145a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010145e:	8b 44 24 10          	mov    0x10(%esp),%eax
f0101462:	89 04 24             	mov    %eax,(%esp)
f0101465:	e8 90 ec ff ff       	call   f01000fa <strcmp>
f010146a:	85 c0                	test   %eax,%eax
f010146c:	75 1d                	jne    f010148b <shell+0x1a6>
f010146e:	6b ff 0c             	imul   $0xc,%edi,%edi
f0101471:	8d 44 24 10          	lea    0x10(%esp),%eax
f0101475:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101479:	89 34 24             	mov    %esi,(%esp)
f010147c:	ff 97 08 70 10 f0    	call   *-0xfef8ff8(%edi)
f0101482:	85 c0                	test   %eax,%eax
f0101484:	78 29                	js     f01014af <shell+0x1ca>
f0101486:	e9 9c fe ff ff       	jmp    f0101327 <shell+0x42>
f010148b:	83 c7 01             	add    $0x1,%edi
f010148e:	83 c3 0c             	add    $0xc,%ebx
f0101491:	83 ff 05             	cmp    $0x5,%edi
f0101494:	75 c2                	jne    f0101458 <shell+0x173>
f0101496:	8b 44 24 10          	mov    0x10(%esp),%eax
f010149a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010149e:	c7 04 24 28 53 10 f0 	movl   $0xf0105328,(%esp)
f01014a5:	e8 2d f0 ff ff       	call   f01004d7 <cprintf>
f01014aa:	e9 78 fe ff ff       	jmp    f0101327 <shell+0x42>
f01014af:	83 c4 5c             	add    $0x5c,%esp
f01014b2:	5b                   	pop    %ebx
f01014b3:	5e                   	pop    %esi
f01014b4:	5f                   	pop    %edi
f01014b5:	5d                   	pop    %ebp
f01014b6:	c3                   	ret    
	...

f01014b8 <user_entry>:
#include <inc/stdio.h>
#include <inc/syscall.h>
#include <inc/shell.h>

int user_entry()
{
f01014b8:	83 ec 1c             	sub    $0x1c,%esp
	//cprintf("in user_entry!\n");

	asm volatile("movl %0,%%eax\n\t" \
f01014bb:	b8 23 00 00 00       	mov    $0x23,%eax
f01014c0:	8e d8                	mov    %eax,%ds
f01014c2:	8e c0                	mov    %eax,%es
f01014c4:	8e e0                	mov    %eax,%fs
f01014c6:	8e e8                	mov    %eax,%gs
    "movw %%ax,%%fs\n\t" \
    "movw %%ax,%%gs" \
    :: "i" (0x20 | 0x03)
  );

  cprintf("Welcome to User Land, cheers!\n");
f01014c8:	c7 04 24 24 54 10 f0 	movl   $0xf0105424,(%esp)
f01014cf:	e8 03 f0 ff ff       	call   f01004d7 <cprintf>
  shell();
f01014d4:	e8 0c fe ff ff       	call   f01012e5 <shell>
f01014d9:	eb fe                	jmp    f01014d9 <user_entry+0x21>
f01014db:	00 00                	add    %al,(%eax)
f01014dd:	00 00                	add    %al,(%eax)
	...

f01014e0 <__udivdi3>:
f01014e0:	55                   	push   %ebp
f01014e1:	89 e5                	mov    %esp,%ebp
f01014e3:	57                   	push   %edi
f01014e4:	56                   	push   %esi
f01014e5:	8d 64 24 e0          	lea    -0x20(%esp),%esp
f01014e9:	8b 45 14             	mov    0x14(%ebp),%eax
f01014ec:	8b 75 08             	mov    0x8(%ebp),%esi
f01014ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01014f2:	85 c0                	test   %eax,%eax
f01014f4:	89 75 e8             	mov    %esi,-0x18(%ebp)
f01014f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01014fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01014fd:	75 39                	jne    f0101538 <__udivdi3+0x58>
f01014ff:	39 f9                	cmp    %edi,%ecx
f0101501:	77 65                	ja     f0101568 <__udivdi3+0x88>
f0101503:	85 c9                	test   %ecx,%ecx
f0101505:	75 0b                	jne    f0101512 <__udivdi3+0x32>
f0101507:	b8 01 00 00 00       	mov    $0x1,%eax
f010150c:	31 d2                	xor    %edx,%edx
f010150e:	f7 f1                	div    %ecx
f0101510:	89 c1                	mov    %eax,%ecx
f0101512:	89 f8                	mov    %edi,%eax
f0101514:	31 d2                	xor    %edx,%edx
f0101516:	f7 f1                	div    %ecx
f0101518:	89 c7                	mov    %eax,%edi
f010151a:	89 f0                	mov    %esi,%eax
f010151c:	f7 f1                	div    %ecx
f010151e:	89 fa                	mov    %edi,%edx
f0101520:	89 c6                	mov    %eax,%esi
f0101522:	89 75 f0             	mov    %esi,-0x10(%ebp)
f0101525:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101528:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010152b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010152e:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101532:	5e                   	pop    %esi
f0101533:	5f                   	pop    %edi
f0101534:	5d                   	pop    %ebp
f0101535:	c3                   	ret    
f0101536:	66 90                	xchg   %ax,%ax
f0101538:	31 d2                	xor    %edx,%edx
f010153a:	31 f6                	xor    %esi,%esi
f010153c:	39 f8                	cmp    %edi,%eax
f010153e:	77 e2                	ja     f0101522 <__udivdi3+0x42>
f0101540:	0f bd d0             	bsr    %eax,%edx
f0101543:	83 f2 1f             	xor    $0x1f,%edx
f0101546:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101549:	75 2d                	jne    f0101578 <__udivdi3+0x98>
f010154b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f010154e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
f0101551:	76 06                	jbe    f0101559 <__udivdi3+0x79>
f0101553:	39 f8                	cmp    %edi,%eax
f0101555:	89 f2                	mov    %esi,%edx
f0101557:	73 c9                	jae    f0101522 <__udivdi3+0x42>
f0101559:	31 d2                	xor    %edx,%edx
f010155b:	be 01 00 00 00       	mov    $0x1,%esi
f0101560:	eb c0                	jmp    f0101522 <__udivdi3+0x42>
f0101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101568:	89 f0                	mov    %esi,%eax
f010156a:	89 fa                	mov    %edi,%edx
f010156c:	f7 f1                	div    %ecx
f010156e:	31 d2                	xor    %edx,%edx
f0101570:	89 c6                	mov    %eax,%esi
f0101572:	eb ae                	jmp    f0101522 <__udivdi3+0x42>
f0101574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101578:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010157c:	89 c2                	mov    %eax,%edx
f010157e:	b8 20 00 00 00       	mov    $0x20,%eax
f0101583:	2b 45 ec             	sub    -0x14(%ebp),%eax
f0101586:	d3 e2                	shl    %cl,%edx
f0101588:	89 c1                	mov    %eax,%ecx
f010158a:	8b 75 f0             	mov    -0x10(%ebp),%esi
f010158d:	d3 ee                	shr    %cl,%esi
f010158f:	09 d6                	or     %edx,%esi
f0101591:	89 fa                	mov    %edi,%edx
f0101593:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101597:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f010159a:	8b 75 f0             	mov    -0x10(%ebp),%esi
f010159d:	d3 e6                	shl    %cl,%esi
f010159f:	89 c1                	mov    %eax,%ecx
f01015a1:	89 75 f0             	mov    %esi,-0x10(%ebp)
f01015a4:	8b 75 e8             	mov    -0x18(%ebp),%esi
f01015a7:	d3 ea                	shr    %cl,%edx
f01015a9:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01015ad:	d3 e7                	shl    %cl,%edi
f01015af:	89 c1                	mov    %eax,%ecx
f01015b1:	d3 ee                	shr    %cl,%esi
f01015b3:	09 fe                	or     %edi,%esi
f01015b5:	89 f0                	mov    %esi,%eax
f01015b7:	f7 75 e4             	divl   -0x1c(%ebp)
f01015ba:	89 d7                	mov    %edx,%edi
f01015bc:	89 c6                	mov    %eax,%esi
f01015be:	f7 65 f0             	mull   -0x10(%ebp)
f01015c1:	39 d7                	cmp    %edx,%edi
f01015c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01015c6:	72 12                	jb     f01015da <__udivdi3+0xfa>
f01015c8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01015cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01015cf:	d3 e2                	shl    %cl,%edx
f01015d1:	39 c2                	cmp    %eax,%edx
f01015d3:	73 08                	jae    f01015dd <__udivdi3+0xfd>
f01015d5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f01015d8:	75 03                	jne    f01015dd <__udivdi3+0xfd>
f01015da:	8d 76 ff             	lea    -0x1(%esi),%esi
f01015dd:	31 d2                	xor    %edx,%edx
f01015df:	e9 3e ff ff ff       	jmp    f0101522 <__udivdi3+0x42>
f01015e4:	47                   	inc    %edi
f01015e5:	43                   	inc    %ebx
f01015e6:	43                   	inc    %ebx
f01015e7:	3a 20                	cmp    (%eax),%ah
f01015e9:	28 47 4e             	sub    %al,0x4e(%edi)
f01015ec:	55                   	push   %ebp
f01015ed:	29 20                	sub    %esp,(%eax)
f01015ef:	34 2e                	xor    $0x2e,%al
f01015f1:	35 2e 31 20 32       	xor    $0x3220312e,%eax
f01015f6:	30 31                	xor    %dh,(%ecx)
f01015f8:	30 30                	xor    %dh,(%eax)
f01015fa:	39 32                	cmp    %esi,(%edx)
f01015fc:	34 20                	xor    $0x20,%al
f01015fe:	28 52 65             	sub    %dl,0x65(%edx)
f0101601:	64 20 48 61          	and    %cl,%fs:0x61(%eax)
f0101605:	74 20                	je     f0101627 <__udivdi3+0x147>
f0101607:	34 2e                	xor    $0x2e,%al
f0101609:	35 2e 31 2d 34       	xor    $0x342d312e,%eax
f010160e:	29 00                	sub    %eax,(%eax)
f0101610:	14 00                	adc    $0x0,%al
f0101612:	00 00                	add    %al,(%eax)
f0101614:	00 00                	add    %al,(%eax)
f0101616:	00 00                	add    %al,(%eax)
f0101618:	01 7a 52             	add    %edi,0x52(%edx)
f010161b:	00 01                	add    %al,(%ecx)
f010161d:	7c 08                	jl     f0101627 <__udivdi3+0x147>
f010161f:	01 1b                	add    %ebx,(%ebx)
f0101621:	0c 04                	or     $0x4,%al
f0101623:	04 88                	add    $0x88,%al
f0101625:	01 00                	add    %eax,(%eax)
f0101627:	00 28                	add    %ch,(%eax)
f0101629:	00 00                	add    %al,(%eax)
f010162b:	00 1c 00             	add    %bl,(%eax,%eax,1)
f010162e:	00 00                	add    %al,(%eax)
f0101630:	b0 fe                	mov    $0xfe,%al
f0101632:	ff                   	(bad)  
f0101633:	ff 04 01             	incl   (%ecx,%eax,1)
f0101636:	00 00                	add    %al,(%eax)
f0101638:	00 41 0e             	add    %al,0xe(%ecx)
f010163b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
f0101641:	4c                   	dec    %esp
f0101642:	86 04 87             	xchg   %al,(%edi,%eax,4)
f0101645:	03 02                	add    (%edx),%eax
f0101647:	44                   	inc    %esp
f0101648:	0a c6                	or     %dh,%al
f010164a:	41                   	inc    %ecx
f010164b:	c7 41 c5 0c 04 04 43 	movl   $0x4304040c,-0x3b(%ecx)
f0101652:	0b 00                	or     (%eax),%eax
	...

f0101660 <__umoddi3>:
f0101660:	55                   	push   %ebp
f0101661:	89 e5                	mov    %esp,%ebp
f0101663:	57                   	push   %edi
f0101664:	56                   	push   %esi
f0101665:	8d 64 24 e0          	lea    -0x20(%esp),%esp
f0101669:	8b 7d 14             	mov    0x14(%ebp),%edi
f010166c:	8b 45 08             	mov    0x8(%ebp),%eax
f010166f:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101672:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101675:	85 ff                	test   %edi,%edi
f0101677:	89 45 e8             	mov    %eax,-0x18(%ebp)
f010167a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f010167d:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101680:	89 f2                	mov    %esi,%edx
f0101682:	75 14                	jne    f0101698 <__umoddi3+0x38>
f0101684:	39 f1                	cmp    %esi,%ecx
f0101686:	76 40                	jbe    f01016c8 <__umoddi3+0x68>
f0101688:	f7 f1                	div    %ecx
f010168a:	89 d0                	mov    %edx,%eax
f010168c:	31 d2                	xor    %edx,%edx
f010168e:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101692:	5e                   	pop    %esi
f0101693:	5f                   	pop    %edi
f0101694:	5d                   	pop    %ebp
f0101695:	c3                   	ret    
f0101696:	66 90                	xchg   %ax,%ax
f0101698:	39 f7                	cmp    %esi,%edi
f010169a:	77 4c                	ja     f01016e8 <__umoddi3+0x88>
f010169c:	0f bd c7             	bsr    %edi,%eax
f010169f:	83 f0 1f             	xor    $0x1f,%eax
f01016a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01016a5:	75 51                	jne    f01016f8 <__umoddi3+0x98>
f01016a7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
f01016aa:	0f 87 e8 00 00 00    	ja     f0101798 <__umoddi3+0x138>
f01016b0:	89 f2                	mov    %esi,%edx
f01016b2:	8b 75 f0             	mov    -0x10(%ebp),%esi
f01016b5:	29 ce                	sub    %ecx,%esi
f01016b7:	19 fa                	sbb    %edi,%edx
f01016b9:	89 75 f0             	mov    %esi,-0x10(%ebp)
f01016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01016bf:	8d 64 24 20          	lea    0x20(%esp),%esp
f01016c3:	5e                   	pop    %esi
f01016c4:	5f                   	pop    %edi
f01016c5:	5d                   	pop    %ebp
f01016c6:	c3                   	ret    
f01016c7:	90                   	nop
f01016c8:	85 c9                	test   %ecx,%ecx
f01016ca:	75 0b                	jne    f01016d7 <__umoddi3+0x77>
f01016cc:	b8 01 00 00 00       	mov    $0x1,%eax
f01016d1:	31 d2                	xor    %edx,%edx
f01016d3:	f7 f1                	div    %ecx
f01016d5:	89 c1                	mov    %eax,%ecx
f01016d7:	89 f0                	mov    %esi,%eax
f01016d9:	31 d2                	xor    %edx,%edx
f01016db:	f7 f1                	div    %ecx
f01016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01016e0:	f7 f1                	div    %ecx
f01016e2:	eb a6                	jmp    f010168a <__umoddi3+0x2a>
f01016e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01016e8:	89 f2                	mov    %esi,%edx
f01016ea:	8d 64 24 20          	lea    0x20(%esp),%esp
f01016ee:	5e                   	pop    %esi
f01016ef:	5f                   	pop    %edi
f01016f0:	5d                   	pop    %ebp
f01016f1:	c3                   	ret    
f01016f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01016f8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01016fc:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
f0101703:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101706:	29 45 f0             	sub    %eax,-0x10(%ebp)
f0101709:	d3 e7                	shl    %cl,%edi
f010170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010170e:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101712:	89 f2                	mov    %esi,%edx
f0101714:	d3 e8                	shr    %cl,%eax
f0101716:	09 f8                	or     %edi,%eax
f0101718:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010171c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010171f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101722:	d3 e0                	shl    %cl,%eax
f0101724:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101728:	89 45 f4             	mov    %eax,-0xc(%ebp)
f010172b:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010172e:	d3 ea                	shr    %cl,%edx
f0101730:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101734:	d3 e6                	shl    %cl,%esi
f0101736:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f010173a:	d3 e8                	shr    %cl,%eax
f010173c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101740:	09 f0                	or     %esi,%eax
f0101742:	8b 75 e8             	mov    -0x18(%ebp),%esi
f0101745:	d3 e6                	shl    %cl,%esi
f0101747:	f7 75 e4             	divl   -0x1c(%ebp)
f010174a:	89 75 e8             	mov    %esi,-0x18(%ebp)
f010174d:	89 d6                	mov    %edx,%esi
f010174f:	f7 65 f4             	mull   -0xc(%ebp)
f0101752:	89 d7                	mov    %edx,%edi
f0101754:	89 c2                	mov    %eax,%edx
f0101756:	39 fe                	cmp    %edi,%esi
f0101758:	89 f9                	mov    %edi,%ecx
f010175a:	72 30                	jb     f010178c <__umoddi3+0x12c>
f010175c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
f010175f:	72 27                	jb     f0101788 <__umoddi3+0x128>
f0101761:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101764:	29 d0                	sub    %edx,%eax
f0101766:	19 ce                	sbb    %ecx,%esi
f0101768:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010176c:	89 f2                	mov    %esi,%edx
f010176e:	d3 e8                	shr    %cl,%eax
f0101770:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101774:	d3 e2                	shl    %cl,%edx
f0101776:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010177a:	09 d0                	or     %edx,%eax
f010177c:	89 f2                	mov    %esi,%edx
f010177e:	d3 ea                	shr    %cl,%edx
f0101780:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101784:	5e                   	pop    %esi
f0101785:	5f                   	pop    %edi
f0101786:	5d                   	pop    %ebp
f0101787:	c3                   	ret    
f0101788:	39 fe                	cmp    %edi,%esi
f010178a:	75 d5                	jne    f0101761 <__umoddi3+0x101>
f010178c:	89 f9                	mov    %edi,%ecx
f010178e:	89 c2                	mov    %eax,%edx
f0101790:	2b 55 f4             	sub    -0xc(%ebp),%edx
f0101793:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0101796:	eb c9                	jmp    f0101761 <__umoddi3+0x101>
f0101798:	39 f7                	cmp    %esi,%edi
f010179a:	0f 82 10 ff ff ff    	jb     f01016b0 <__umoddi3+0x50>
f01017a0:	e9 17 ff ff ff       	jmp    f01016bc <__umoddi3+0x5c>
f01017a5:	00 00                	add    %al,(%eax)
f01017a7:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
f01017ab:	00 9c 01 00 00 b0 fe 	add    %bl,-0x1500000(%ecx,%eax,1)
f01017b2:	ff                   	(bad)  
f01017b3:	ff 45 01             	incl   0x1(%ebp)
f01017b6:	00 00                	add    %al,(%eax)
f01017b8:	00 41 0e             	add    %al,0xe(%ecx)
f01017bb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
f01017c1:	49                   	dec    %ecx
f01017c2:	86 04 87             	xchg   %al,(%edi,%eax,4)
f01017c5:	03 67 0a             	add    0xa(%edi),%esp
f01017c8:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f01017cc:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
f01017cf:	04 43                	add    $0x43,%al
f01017d1:	0b 6c 0a c6          	or     -0x3a(%edx,%ecx,1),%ebp
f01017d5:	41                   	inc    %ecx
f01017d6:	c7 41 0c 04 04 c5 42 	movl   $0x42c50404,0xc(%ecx)
f01017dd:	0b 67 0a             	or     0xa(%edi),%esp
f01017e0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f01017e4:	0c 04                	or     $0x4,%al
f01017e6:	04 c5                	add    $0xc5,%al
f01017e8:	47                   	inc    %edi
f01017e9:	0b 02                	or     (%edx),%eax
f01017eb:	8d 0a                	lea    (%edx),%ecx
f01017ed:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f01017f1:	0c 04                	or     $0x4,%al
f01017f3:	04 c5                	add    $0xc5,%al
f01017f5:	41                   	inc    %ecx
f01017f6:	0b 00                	or     (%eax),%eax

f01017f8 <UTEXT_end>:
.global entry
_start = RELOC(entry)

.text
entry:
	movw	$0x1234,0x472			# warm boot
f01017f8:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f01017ff:	34 12 
	# KERNBASE+1MB.  Hence, we set up a trivial page directory that
	# translates virtual addresses [KERNBASE, KERNBASE+4MB) to
	# physical addresses [0, 4MB).  This 4MB region will be
	# sufficient until we set up our real page table in mem_init.

    movl $0, %eax
f0101801:	b8 00 00 00 00       	mov    $0x0,%eax
    movl $(RELOC(bss_start)), %edi
f0101806:	bf 38 a0 10 00       	mov    $0x10a038,%edi
    movl $(RELOC(end)), %ecx
f010180b:	b9 38 7c 11 00       	mov    $0x117c38,%ecx
    subl %edi, %ecx
f0101810:	29 f9                	sub    %edi,%ecx
    cld
f0101812:	fc                   	cld    
    rep stosb
f0101813:	f3 aa                	rep stos %al,%es:(%edi)

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0101815:	b8 00 80 10 00       	mov    $0x108000,%eax
	movl	%eax, %cr3
f010181a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010181d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0101820:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0101825:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0101828:	b8 2f 18 10 f0       	mov    $0xf010182f,%eax
	jmp	*%eax
f010182d:	ff e0                	jmp    *%eax

f010182f <relocated>:

relocated:

  # Setup new gdt
  lgdt    kgdtdesc
f010182f:	0f 01 15 60 18 10 f0 	lgdtl  0xf0101860

	# Setup kernel stack
	movl $0, %ebp
f0101836:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl $(bootstacktop), %esp
f010183b:	bc 00 40 11 f0       	mov    $0xf0114000,%esp

	call kernel_main
f0101840:	e8 23 00 00 00       	call   f0101868 <kernel_main>

f0101845 <die>:
die:
	jmp die
f0101845:	eb fe                	jmp    f0101845 <die>
f0101847:	90                   	nop

f0101848 <kgdt>:
	...
f0101850:	ff                   	(bad)  
f0101851:	ff 00                	incl   (%eax)
f0101853:	00 00                	add    %al,(%eax)
f0101855:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010185c:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0101860 <kgdtdesc>:
f0101860:	17                   	pop    %ss
f0101861:	00 48 18             	add    %cl,0x18(%eax)
f0101864:	10 f0                	adc    %dh,%al
	...

f0101868 <kernel_main>:

extern void init_video(void);
extern Task *cur_task;

void kernel_main(void)
{
f0101868:	83 ec 0c             	sub    $0xc,%esp
	extern char stext[];
	extern char etext[], end[], data_start[],rdata_end[];
	extern void task_job();

	init_video();
f010186b:	e8 bd 04 00 00       	call   f0101d2d <init_video>

	trap_init();
f0101870:	e8 f2 07 00 00       	call   f0102067 <trap_init>
	pic_init();
f0101875:	e8 c2 00 00 00       	call   f010193c <pic_init>
	kbd_init();
f010187a:	e8 65 02 00 00       	call   f0101ae4 <kbd_init>
  mem_init();
f010187f:	e8 b2 0f 00 00       	call   f0102836 <mem_init>

  printk("Kernel code base start=0x%08x to = 0x%08x\n", stext, etext);
f0101884:	50                   	push   %eax
f0101885:	68 d8 43 10 f0       	push   $0xf01043d8
f010188a:	68 00 00 10 f0       	push   $0xf0100000
f010188f:	68 44 54 10 f0       	push   $0xf0105444
f0101894:	e8 37 09 00 00       	call   f01021d0 <printk>
  printk("Readonly data start=0x%08x to = 0x%08x\n", etext, rdata_end);
f0101899:	83 c4 0c             	add    $0xc,%esp
f010189c:	68 7f 66 10 f0       	push   $0xf010667f
f01018a1:	68 d8 43 10 f0       	push   $0xf01043d8
f01018a6:	68 6f 54 10 f0       	push   $0xf010546f
f01018ab:	e8 20 09 00 00       	call   f01021d0 <printk>
  printk("Kernel data base start=0x%08x to = 0x%08x\n", data_start, end);
f01018b0:	83 c4 0c             	add    $0xc,%esp
f01018b3:	68 38 7c 11 f0       	push   $0xf0117c38
f01018b8:	68 00 70 10 f0       	push   $0xf0107000
f01018bd:	68 97 54 10 f0       	push   $0xf0105497
f01018c2:	e8 09 09 00 00       	call   f01021d0 <printk>
  timer_init();
f01018c7:	e8 b6 24 00 00       	call   f0103d82 <timer_init>
  syscall_init();
f01018cc:	e8 2a 2a 00 00       	call   f01042fb <syscall_init>

  task_init();
f01018d1:	e8 a4 27 00 00       	call   f010407a <task_init>
	
	//printk("after task_init() in main.c\n");
  /* Enable interrupt */
  __asm __volatile("sti");
f01018d6:	fb                   	sti    
	
	//printk("after __volatile() in main.c\n");
  lcr3(PADDR(cur_task->pgdir));
f01018d7:	8b 15 2c 4e 11 f0    	mov    0xf0114e2c,%edx
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01018dd:	83 c4 10             	add    $0x10,%esp
f01018e0:	8b 42 54             	mov    0x54(%edx),%eax
f01018e3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01018e8:	77 12                	ja     f01018fc <kernel_main+0x94>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01018ea:	50                   	push   %eax
f01018eb:	68 c2 54 10 f0       	push   $0xf01054c2
f01018f0:	6a 29                	push   $0x29
f01018f2:	68 e6 54 10 f0       	push   $0xf01054e6
f01018f7:	e8 44 23 00 00       	call   f0103c40 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01018fc:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0101901:	0f 22 d8             	mov    %eax,%cr3

	//printk("after lcr3() in main.c\n");
  /* Move to user mode */
  asm volatile("movl %0,%%eax\n\t" \
f0101904:	8b 42 44             	mov    0x44(%edx),%eax
f0101907:	6a 23                	push   $0x23
f0101909:	50                   	push   %eax
f010190a:	9c                   	pushf  
f010190b:	6a 1b                	push   $0x1b
f010190d:	ff 72 38             	pushl  0x38(%edx)
f0101910:	cf                   	iret   
  "pushl %3\n\t" \
  "iret\n" \
  :: "m" (cur_task->tf.tf_esp), "i" (GD_UD | 0x03), "i" (GD_UT | 0x03), "m" (cur_task->tf.tf_eip)
  :"ax");
	//printk("end kernel main.c\n");
}
f0101911:	83 c4 0c             	add    $0xc,%esp
f0101914:	c3                   	ret    
f0101915:	00 00                	add    %al,(%eax)
	...

f0101918 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0101918:	8b 54 24 04          	mov    0x4(%esp),%edx
	irq_mask_8259A = mask;
	if (!didinit)
f010191c:	80 3d 00 40 11 f0 00 	cmpb   $0x0,0xf0114000
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0101923:	89 d0                	mov    %edx,%eax
	irq_mask_8259A = mask;
f0101925:	66 89 15 3c 70 10 f0 	mov    %dx,0xf010703c
	if (!didinit)
f010192c:	74 0d                	je     f010193b <irq_setmask_8259A+0x23>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010192e:	ba 21 00 00 00       	mov    $0x21,%edx
f0101933:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f0101934:	66 c1 e8 08          	shr    $0x8,%ax
f0101938:	b2 a1                	mov    $0xa1,%dl
f010193a:	ee                   	out    %al,(%dx)
f010193b:	c3                   	ret    

f010193c <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f010193c:	57                   	push   %edi
f010193d:	b9 21 00 00 00       	mov    $0x21,%ecx
f0101942:	56                   	push   %esi
f0101943:	b0 ff                	mov    $0xff,%al
f0101945:	53                   	push   %ebx
f0101946:	89 ca                	mov    %ecx,%edx
f0101948:	ee                   	out    %al,(%dx)
f0101949:	be a1 00 00 00       	mov    $0xa1,%esi
f010194e:	89 f2                	mov    %esi,%edx
f0101950:	ee                   	out    %al,(%dx)
f0101951:	bf 11 00 00 00       	mov    $0x11,%edi
f0101956:	bb 20 00 00 00       	mov    $0x20,%ebx
f010195b:	89 f8                	mov    %edi,%eax
f010195d:	89 da                	mov    %ebx,%edx
f010195f:	ee                   	out    %al,(%dx)
f0101960:	b0 20                	mov    $0x20,%al
f0101962:	89 ca                	mov    %ecx,%edx
f0101964:	ee                   	out    %al,(%dx)
f0101965:	b0 04                	mov    $0x4,%al
f0101967:	ee                   	out    %al,(%dx)
f0101968:	b0 03                	mov    $0x3,%al
f010196a:	ee                   	out    %al,(%dx)
f010196b:	b1 a0                	mov    $0xa0,%cl
f010196d:	89 f8                	mov    %edi,%eax
f010196f:	89 ca                	mov    %ecx,%edx
f0101971:	ee                   	out    %al,(%dx)
f0101972:	b0 28                	mov    $0x28,%al
f0101974:	89 f2                	mov    %esi,%edx
f0101976:	ee                   	out    %al,(%dx)
f0101977:	b0 02                	mov    $0x2,%al
f0101979:	ee                   	out    %al,(%dx)
f010197a:	b0 01                	mov    $0x1,%al
f010197c:	ee                   	out    %al,(%dx)
f010197d:	bf 68 00 00 00       	mov    $0x68,%edi
f0101982:	89 da                	mov    %ebx,%edx
f0101984:	89 f8                	mov    %edi,%eax
f0101986:	ee                   	out    %al,(%dx)
f0101987:	be 0a 00 00 00       	mov    $0xa,%esi
f010198c:	89 f0                	mov    %esi,%eax
f010198e:	ee                   	out    %al,(%dx)
f010198f:	89 f8                	mov    %edi,%eax
f0101991:	89 ca                	mov    %ecx,%edx
f0101993:	ee                   	out    %al,(%dx)
f0101994:	89 f0                	mov    %esi,%eax
f0101996:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0101997:	66 a1 3c 70 10 f0    	mov    0xf010703c,%ax

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f010199d:	c6 05 00 40 11 f0 01 	movb   $0x1,0xf0114000
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f01019a4:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f01019a8:	74 0a                	je     f01019b4 <pic_init+0x78>
		irq_setmask_8259A(irq_mask_8259A);
f01019aa:	0f b7 c0             	movzwl %ax,%eax
f01019ad:	50                   	push   %eax
f01019ae:	e8 65 ff ff ff       	call   f0101918 <irq_setmask_8259A>
f01019b3:	58                   	pop    %eax
}
f01019b4:	5b                   	pop    %ebx
f01019b5:	5e                   	pop    %esi
f01019b6:	5f                   	pop    %edi
f01019b7:	c3                   	ret    

f01019b8 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f01019b8:	53                   	push   %ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01019b9:	ba 64 00 00 00       	mov    $0x64,%edx
f01019be:	83 ec 08             	sub    $0x8,%esp
f01019c1:	ec                   	in     (%dx),%al
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
    return -1;
f01019c2:	83 c9 ff             	or     $0xffffffff,%ecx
{
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
f01019c5:	a8 01                	test   $0x1,%al
f01019c7:	0f 84 ae 00 00 00    	je     f0101a7b <kbd_proc_data+0xc3>
f01019cd:	b2 60                	mov    $0x60,%dl
f01019cf:	ec                   	in     (%dx),%al
    return -1;

  data = inb(KBDATAP);

  if (data == 0xE0) {
f01019d0:	3c e0                	cmp    $0xe0,%al
f01019d2:	88 c1                	mov    %al,%cl
f01019d4:	75 12                	jne    f01019e8 <kbd_proc_data+0x30>
f01019d6:	ec                   	in     (%dx),%al
    data = inb(KBDATAP);
    if (data & 0x80)
      return 0;
f01019d7:	31 c9                	xor    %ecx,%ecx

  data = inb(KBDATAP);

  if (data == 0xE0) {
    data = inb(KBDATAP);
    if (data & 0x80)
f01019d9:	84 c0                	test   %al,%al
f01019db:	0f 88 9a 00 00 00    	js     f0101a7b <kbd_proc_data+0xc3>
      return 0;
    else
      data |= 0x80;
f01019e1:	88 c1                	mov    %al,%cl
f01019e3:	83 c9 80             	or     $0xffffff80,%ecx
f01019e6:	eb 1a                	jmp    f0101a02 <kbd_proc_data+0x4a>
  } else if (data & 0x80) {
f01019e8:	84 c0                	test   %al,%al
f01019ea:	79 16                	jns    f0101a02 <kbd_proc_data+0x4a>
    // Key released
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
f01019ec:	83 e0 7f             	and    $0x7f,%eax
    return 0;
f01019ef:	31 c9                	xor    %ecx,%ecx
    else
      data |= 0x80;
  } else if (data & 0x80) {
    // Key released
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
f01019f1:	0f b6 80 00 55 10 f0 	movzbl -0xfefab00(%eax),%eax
f01019f8:	f7 d0                	not    %eax
f01019fa:	21 05 0c 42 11 f0    	and    %eax,0xf011420c
    return 0;
f0101a00:	eb 79                	jmp    f0101a7b <kbd_proc_data+0xc3>
  }

  shift |= shiftcode[data];
f0101a02:	0f b6 c1             	movzbl %cl,%eax
  shift ^= togglecode[data];
f0101a05:	0f b6 90 00 56 10 f0 	movzbl -0xfefaa00(%eax),%edx
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
    return 0;
  }

  shift |= shiftcode[data];
f0101a0c:	0f b6 98 00 55 10 f0 	movzbl -0xfefab00(%eax),%ebx
f0101a13:	0b 1d 0c 42 11 f0    	or     0xf011420c,%ebx
  shift ^= togglecode[data];
f0101a19:	31 d3                	xor    %edx,%ebx

  c = charcode[shift & (CTL | SHIFT)][data];
f0101a1b:	89 da                	mov    %ebx,%edx
f0101a1d:	83 e2 03             	and    $0x3,%edx
  if (shift & CAPSLOCK) {
f0101a20:	f6 c3 08             	test   $0x8,%bl
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];

  c = charcode[shift & (CTL | SHIFT)][data];
f0101a23:	8b 14 95 00 57 10 f0 	mov    -0xfefa900(,%edx,4),%edx
    shift &= ~(shiftcode[data]);
    return 0;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
f0101a2a:	89 1d 0c 42 11 f0    	mov    %ebx,0xf011420c

  c = charcode[shift & (CTL | SHIFT)][data];
f0101a30:	0f b6 0c 02          	movzbl (%edx,%eax,1),%ecx
  if (shift & CAPSLOCK) {
f0101a34:	74 19                	je     f0101a4f <kbd_proc_data+0x97>
    if ('a' <= c && c <= 'z')
f0101a36:	8d 41 9f             	lea    -0x61(%ecx),%eax
f0101a39:	83 f8 19             	cmp    $0x19,%eax
f0101a3c:	77 05                	ja     f0101a43 <kbd_proc_data+0x8b>
      c += 'A' - 'a';
f0101a3e:	83 e9 20             	sub    $0x20,%ecx
f0101a41:	eb 0c                	jmp    f0101a4f <kbd_proc_data+0x97>
    else if ('A' <= c && c <= 'Z')
f0101a43:	8d 51 bf             	lea    -0x41(%ecx),%edx
      c += 'a' - 'A';
f0101a46:	8d 41 20             	lea    0x20(%ecx),%eax
f0101a49:	83 fa 19             	cmp    $0x19,%edx
f0101a4c:	0f 46 c8             	cmovbe %eax,%ecx
  }

  // Process special keys
  // Ctrl-Alt-Del: reboot
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0101a4f:	81 f9 e9 00 00 00    	cmp    $0xe9,%ecx
f0101a55:	75 24                	jne    f0101a7b <kbd_proc_data+0xc3>
f0101a57:	f7 d3                	not    %ebx
f0101a59:	80 e3 06             	and    $0x6,%bl
f0101a5c:	75 1d                	jne    f0101a7b <kbd_proc_data+0xc3>
    printk("Rebooting!\n");
f0101a5e:	83 ec 0c             	sub    $0xc,%esp
f0101a61:	68 f4 54 10 f0       	push   $0xf01054f4
f0101a66:	e8 65 07 00 00       	call   f01021d0 <printk>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0101a6b:	ba 92 00 00 00       	mov    $0x92,%edx
f0101a70:	b0 03                	mov    $0x3,%al
f0101a72:	ee                   	out    %al,(%dx)
f0101a73:	b9 e9 00 00 00       	mov    $0xe9,%ecx
f0101a78:	83 c4 10             	add    $0x10,%esp
    outb(0x92, 0x3); // courtesy of Chris Frost
  }

  return c;
}
f0101a7b:	89 c8                	mov    %ecx,%eax
f0101a7d:	83 c4 08             	add    $0x8,%esp
f0101a80:	5b                   	pop    %ebx
f0101a81:	c3                   	ret    

f0101a82 <kbd_intr>:
/* 
 *  Note: The interrupt handler
 */
void
kbd_intr(struct Trapframe *tf)
{
f0101a82:	83 ec 0c             	sub    $0xc,%esp
f0101a85:	eb 23                	jmp    f0101aaa <kbd_intr+0x28>
cons_intr(int (*proc)(void))
{
  int c;

  while ((c = (*proc)()) != -1) {
    if (c == 0)
f0101a87:	85 c0                	test   %eax,%eax
f0101a89:	74 1f                	je     f0101aaa <kbd_intr+0x28>
      continue;

    cons.buf[cons.wpos++] = c;
f0101a8b:	8b 15 08 42 11 f0    	mov    0xf0114208,%edx
f0101a91:	88 82 04 40 11 f0    	mov    %al,-0xfeebffc(%edx)
f0101a97:	42                   	inc    %edx
    if (cons.wpos == CONSBUFSIZE)
      cons.wpos = 0;
f0101a98:	31 c0                	xor    %eax,%eax
f0101a9a:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0101aa0:	0f 45 c2             	cmovne %edx,%eax
f0101aa3:	a3 08 42 11 f0       	mov    %eax,0xf0114208
f0101aa8:	eb 0a                	jmp    f0101ab4 <kbd_intr+0x32>
  static void
cons_intr(int (*proc)(void))
{
  int c;

  while ((c = (*proc)()) != -1) {
f0101aaa:	e8 09 ff ff ff       	call   f01019b8 <kbd_proc_data>
f0101aaf:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101ab2:	75 d3                	jne    f0101a87 <kbd_intr+0x5>
 */
void
kbd_intr(struct Trapframe *tf)
{
  cons_intr(kbd_proc_data);
}
f0101ab4:	83 c4 0c             	add    $0xc,%esp
f0101ab7:	c3                   	ret    

f0101ab8 <cons_getc>:
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  //kbd_intr();

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
f0101ab8:	8b 15 04 42 11 f0    	mov    0xf0114204,%edx
    c = cons.buf[cons.rpos++];
    if (cons.rpos == CONSBUFSIZE)
      cons.rpos = 0;
    return c;
  }
  return 0;
f0101abe:	31 c0                	xor    %eax,%eax
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  //kbd_intr();

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
f0101ac0:	3b 15 08 42 11 f0    	cmp    0xf0114208,%edx
f0101ac6:	74 1b                	je     f0101ae3 <cons_getc+0x2b>
    c = cons.buf[cons.rpos++];
f0101ac8:	8d 4a 01             	lea    0x1(%edx),%ecx
f0101acb:	0f b6 82 04 40 11 f0 	movzbl -0xfeebffc(%edx),%eax
    if (cons.rpos == CONSBUFSIZE)
      cons.rpos = 0;
f0101ad2:	31 d2                	xor    %edx,%edx
f0101ad4:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0101ada:	0f 45 d1             	cmovne %ecx,%edx
f0101add:	89 15 04 42 11 f0    	mov    %edx,0xf0114204
    return c;
  }
  return 0;
}
f0101ae3:	c3                   	ret    

f0101ae4 <kbd_init>:
{
  cons_intr(kbd_proc_data);
}

void kbd_init(void)
{
f0101ae4:	83 ec 18             	sub    $0x18,%esp
  // Drain the kbd buffer so that Bochs generates interrupts.
  kbd_intr(NULL);
f0101ae7:	6a 00                	push   $0x0
f0101ae9:	e8 94 ff ff ff       	call   f0101a82 <kbd_intr>
  irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f0101aee:	0f b7 05 3c 70 10 f0 	movzwl 0xf010703c,%eax
f0101af5:	25 fd ff 00 00       	and    $0xfffd,%eax
f0101afa:	89 04 24             	mov    %eax,(%esp)
f0101afd:	e8 16 fe ff ff       	call   f0101918 <irq_setmask_8259A>
  /* Register trap handler */
  extern void KBD_Input();
  register_handler( IRQ_OFFSET + IRQ_KBD, &kbd_intr, &KBD_Input, 0, 0);
f0101b02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101b09:	6a 00                	push   $0x0
f0101b0b:	68 36 21 10 f0       	push   $0xf0102136
f0101b10:	68 82 1a 10 f0       	push   $0xf0101a82
f0101b15:	6a 21                	push   $0x21
f0101b17:	e8 29 04 00 00       	call   f0101f45 <register_handler>
}
f0101b1c:	83 c4 2c             	add    $0x2c,%esp
f0101b1f:	c3                   	ret    

f0101b20 <k_getc>:
int k_getc(void)
{
  // In lab4, our task is switched to user mode, so dont block at there
  //while ((c = cons_getc()) == 0)
  /* do nothing *///;
  return cons_getc();
f0101b20:	e9 93 ff ff ff       	jmp    f0101ab8 <cons_getc>
f0101b25:	00 00                	add    %al,(%eax)
	...

f0101b28 <scroll>:
int attrib = 0x0F;
int csr_x = 0, csr_y = 0;

/* Scrolls the screen */
void scroll(void)
{
f0101b28:	56                   	push   %esi
f0101b29:	53                   	push   %ebx
f0101b2a:	83 ec 04             	sub    $0x4,%esp
    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
f0101b2d:	8b 1d 14 42 11 f0    	mov    0xf0114214,%ebx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
f0101b33:	8b 35 40 73 10 f0    	mov    0xf0107340,%esi

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
f0101b39:	83 fb 18             	cmp    $0x18,%ebx
f0101b3c:	7e 5b                	jle    f0101b99 <scroll+0x71>
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
f0101b3e:	83 eb 18             	sub    $0x18,%ebx
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101b41:	a1 c0 76 11 f0       	mov    0xf01176c0,%eax
f0101b46:	0f b7 db             	movzwl %bx,%ebx
f0101b49:	52                   	push   %edx
f0101b4a:	69 d3 60 ff ff ff    	imul   $0xffffff60,%ebx,%edx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
f0101b50:	c1 e6 08             	shl    $0x8,%esi
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101b53:	0f b7 f6             	movzwl %si,%esi
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101b56:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0101b5c:	52                   	push   %edx
f0101b5d:	69 d3 a0 00 00 00    	imul   $0xa0,%ebx,%edx

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101b63:	6b db b0             	imul   $0xffffffb0,%ebx,%ebx
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101b66:	8d 14 10             	lea    (%eax,%edx,1),%edx
f0101b69:	52                   	push   %edx
f0101b6a:	50                   	push   %eax
f0101b6b:	e8 39 e7 ff ff       	call   f01002a9 <memcpy>

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101b70:	83 c4 0c             	add    $0xc,%esp
f0101b73:	8d 84 1b a0 0f 00 00 	lea    0xfa0(%ebx,%ebx,1),%eax
f0101b7a:	03 05 c0 76 11 f0    	add    0xf01176c0,%eax
f0101b80:	68 a0 00 00 00       	push   $0xa0
f0101b85:	56                   	push   %esi
f0101b86:	50                   	push   %eax
f0101b87:	e8 43 e6 ff ff       	call   f01001cf <memset>
        csr_y = 25 - 1;
f0101b8c:	83 c4 10             	add    $0x10,%esp
f0101b8f:	c7 05 14 42 11 f0 18 	movl   $0x18,0xf0114214
f0101b96:	00 00 00 
    }
}
f0101b99:	83 c4 04             	add    $0x4,%esp
f0101b9c:	5b                   	pop    %ebx
f0101b9d:	5e                   	pop    %esi
f0101b9e:	c3                   	ret    

f0101b9f <move_csr>:
    unsigned short temp;

    /* The equation for finding the index in a linear
    *  chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    temp = csr_y * 80 + csr_x;
f0101b9f:	66 6b 0d 14 42 11 f0 	imul   $0x50,0xf0114214,%cx
f0101ba6:	50 
f0101ba7:	ba d4 03 00 00       	mov    $0x3d4,%edx
f0101bac:	03 0d 10 42 11 f0    	add    0xf0114210,%ecx
f0101bb2:	b0 0e                	mov    $0xe,%al
f0101bb4:	ee                   	out    %al,(%dx)
    *  where the hardware cursor is to be 'blinking'. To
    *  learn more, you should look up some VGA specific
    *  programming documents. A great start to graphics:
    *  http://www.brackeen.com/home/vga */
    outb(0x3D4, 14);
    outb(0x3D5, temp >> 8);
f0101bb5:	89 c8                	mov    %ecx,%eax
f0101bb7:	b2 d5                	mov    $0xd5,%dl
f0101bb9:	66 c1 e8 08          	shr    $0x8,%ax
f0101bbd:	ee                   	out    %al,(%dx)
f0101bbe:	b0 0f                	mov    $0xf,%al
f0101bc0:	b2 d4                	mov    $0xd4,%dl
f0101bc2:	ee                   	out    %al,(%dx)
f0101bc3:	b2 d5                	mov    $0xd5,%dl
f0101bc5:	88 c8                	mov    %cl,%al
f0101bc7:	ee                   	out    %al,(%dx)
    outb(0x3D4, 15);
    outb(0x3D5, temp);
}
f0101bc8:	c3                   	ret    

f0101bc9 <sys_cls>:

/* Clears the screen */
void sys_cls()
{
f0101bc9:	56                   	push   %esi
f0101bca:	53                   	push   %ebx
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
f0101bcb:	31 db                	xor    %ebx,%ebx
    outb(0x3D5, temp);
}

/* Clears the screen */
void sys_cls()
{
f0101bcd:	83 ec 04             	sub    $0x4,%esp
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
f0101bd0:	8b 35 40 73 10 f0    	mov    0xf0107340,%esi
f0101bd6:	c1 e6 08             	shl    $0x8,%esi

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
        memset (textmemptr + i * 80, blank, 80 * 2);
f0101bd9:	0f b7 f6             	movzwl %si,%esi
f0101bdc:	a1 c0 76 11 f0       	mov    0xf01176c0,%eax
f0101be1:	51                   	push   %ecx
f0101be2:	68 a0 00 00 00       	push   $0xa0
f0101be7:	56                   	push   %esi
f0101be8:	01 d8                	add    %ebx,%eax
f0101bea:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
f0101bf0:	50                   	push   %eax
f0101bf1:	e8 d9 e5 ff ff       	call   f01001cf <memset>
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
f0101bf6:	83 c4 10             	add    $0x10,%esp
f0101bf9:	81 fb a0 0f 00 00    	cmp    $0xfa0,%ebx
f0101bff:	75 db                	jne    f0101bdc <sys_cls+0x13>
        memset (textmemptr + i * 80, blank, 80 * 2);

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
f0101c01:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101c08:	00 00 00 
    csr_y = 0;
f0101c0b:	c7 05 14 42 11 f0 00 	movl   $0x0,0xf0114214
f0101c12:	00 00 00 
    move_csr();
}
f0101c15:	83 c4 04             	add    $0x4,%esp
f0101c18:	5b                   	pop    %ebx
f0101c19:	5e                   	pop    %esi

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
    csr_y = 0;
    move_csr();
f0101c1a:	e9 80 ff ff ff       	jmp    f0101b9f <move_csr>

f0101c1f <k_putch>:
}

/* Puts a single character on the screen */
void k_putch(unsigned char c)
{
f0101c1f:	53                   	push   %ebx
f0101c20:	83 ec 08             	sub    $0x8,%esp
    unsigned short *where;
    unsigned short att = attrib << 8;
f0101c23:	8b 0d 40 73 10 f0    	mov    0xf0107340,%ecx
    move_csr();
}

/* Puts a single character on the screen */
void k_putch(unsigned char c)
{
f0101c29:	8a 44 24 10          	mov    0x10(%esp),%al
    unsigned short *where;
    unsigned short att = attrib << 8;
f0101c2d:	c1 e1 08             	shl    $0x8,%ecx

    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
f0101c30:	3c 08                	cmp    $0x8,%al
f0101c32:	75 21                	jne    f0101c55 <k_putch+0x36>
    {
        if(csr_x != 0) {
f0101c34:	a1 10 42 11 f0       	mov    0xf0114210,%eax
f0101c39:	85 c0                	test   %eax,%eax
f0101c3b:	74 7d                	je     f0101cba <k_putch+0x9b>
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
f0101c3d:	6b 15 14 42 11 f0 50 	imul   $0x50,0xf0114214,%edx
f0101c44:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
          *where = 0x0 | att;	/* Character AND attributes: color */
f0101c48:	8b 15 c0 76 11 f0    	mov    0xf01176c0,%edx
          csr_x--;
f0101c4e:	48                   	dec    %eax
    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
    {
        if(csr_x != 0) {
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
          *where = 0x0 | att;	/* Character AND attributes: color */
f0101c4f:	66 89 0c 5a          	mov    %cx,(%edx,%ebx,2)
f0101c53:	eb 0f                	jmp    f0101c64 <k_putch+0x45>
          csr_x--;
        }
    }
    /* Handles a tab by incrementing the cursor's x, but only
    *  to a point that will make it divisible by 8 */
    else if(c == 0x09)
f0101c55:	3c 09                	cmp    $0x9,%al
f0101c57:	75 12                	jne    f0101c6b <k_putch+0x4c>
    {
        csr_x = (csr_x + 8) & ~(8 - 1);
f0101c59:	a1 10 42 11 f0       	mov    0xf0114210,%eax
f0101c5e:	83 c0 08             	add    $0x8,%eax
f0101c61:	83 e0 f8             	and    $0xfffffff8,%eax
f0101c64:	a3 10 42 11 f0       	mov    %eax,0xf0114210
f0101c69:	eb 4f                	jmp    f0101cba <k_putch+0x9b>
    }
    /* Handles a 'Carriage Return', which simply brings the
    *  cursor back to the margin */
    else if(c == '\r')
f0101c6b:	3c 0d                	cmp    $0xd,%al
f0101c6d:	75 0c                	jne    f0101c7b <k_putch+0x5c>
    {
        csr_x = 0;
f0101c6f:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101c76:	00 00 00 
f0101c79:	eb 3f                	jmp    f0101cba <k_putch+0x9b>
    }
    /* We handle our newlines the way DOS and the BIOS do: we
    *  treat it as if a 'CR' was also there, so we bring the
    *  cursor to the margin and we increment the 'y' value */
    else if(c == '\n')
f0101c7b:	3c 0a                	cmp    $0xa,%al
f0101c7d:	75 12                	jne    f0101c91 <k_putch+0x72>
    {
        csr_x = 0;
f0101c7f:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101c86:	00 00 00 
        csr_y++;
f0101c89:	ff 05 14 42 11 f0    	incl   0xf0114214
f0101c8f:	eb 29                	jmp    f0101cba <k_putch+0x9b>
    }
    /* Any character greater than and including a space, is a
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
f0101c91:	3c 1f                	cmp    $0x1f,%al
f0101c93:	76 25                	jbe    f0101cba <k_putch+0x9b>
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101c95:	8b 15 10 42 11 f0    	mov    0xf0114210,%edx
        *where = c | att;	/* Character AND attributes: color */
f0101c9b:	0f b6 c0             	movzbl %al,%eax
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101c9e:	6b 1d 14 42 11 f0 50 	imul   $0x50,0xf0114214,%ebx
        *where = c | att;	/* Character AND attributes: color */
f0101ca5:	09 c8                	or     %ecx,%eax
f0101ca7:	8b 0d c0 76 11 f0    	mov    0xf01176c0,%ecx
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101cad:	01 d3                	add    %edx,%ebx
        *where = c | att;	/* Character AND attributes: color */
        csr_x++;
f0101caf:	42                   	inc    %edx
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
        *where = c | att;	/* Character AND attributes: color */
f0101cb0:	66 89 04 59          	mov    %ax,(%ecx,%ebx,2)
        csr_x++;
f0101cb4:	89 15 10 42 11 f0    	mov    %edx,0xf0114210
    }

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
f0101cba:	83 3d 10 42 11 f0 4f 	cmpl   $0x4f,0xf0114210
f0101cc1:	7e 10                	jle    f0101cd3 <k_putch+0xb4>
    {
        csr_x = 0;
        csr_y++;
f0101cc3:	ff 05 14 42 11 f0    	incl   0xf0114214

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
    {
        csr_x = 0;
f0101cc9:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101cd0:	00 00 00 
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
f0101cd3:	e8 50 fe ff ff       	call   f0101b28 <scroll>
    move_csr();
}
f0101cd8:	83 c4 08             	add    $0x8,%esp
f0101cdb:	5b                   	pop    %ebx
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
    move_csr();
f0101cdc:	e9 be fe ff ff       	jmp    f0101b9f <move_csr>

f0101ce1 <k_puts>:
}

/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
f0101ce1:	56                   	push   %esi
f0101ce2:	53                   	push   %ebx
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101ce3:	31 db                	xor    %ebx,%ebx
    move_csr();
}

/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
f0101ce5:	83 ec 04             	sub    $0x4,%esp
f0101ce8:	8b 74 24 10          	mov    0x10(%esp),%esi
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101cec:	eb 11                	jmp    f0101cff <k_puts+0x1e>
    {
        k_putch(text[i]);
f0101cee:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
f0101cf2:	83 ec 0c             	sub    $0xc,%esp
/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101cf5:	43                   	inc    %ebx
    {
        k_putch(text[i]);
f0101cf6:	50                   	push   %eax
f0101cf7:	e8 23 ff ff ff       	call   f0101c1f <k_putch>
/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101cfc:	83 c4 10             	add    $0x10,%esp
f0101cff:	83 ec 0c             	sub    $0xc,%esp
f0101d02:	56                   	push   %esi
f0101d03:	e8 f8 e2 ff ff       	call   f0100000 <strlen>
f0101d08:	83 c4 10             	add    $0x10,%esp
f0101d0b:	39 c3                	cmp    %eax,%ebx
f0101d0d:	7c df                	jl     f0101cee <k_puts+0xd>
    {
        k_putch(text[i]);
    }
}
f0101d0f:	83 c4 04             	add    $0x4,%esp
f0101d12:	5b                   	pop    %ebx
f0101d13:	5e                   	pop    %esi
f0101d14:	c3                   	ret    

f0101d15 <sys_settextcolor>:

/* Sets the forecolor and backcolor that we will use */
void sys_settextcolor(unsigned char forecolor, unsigned char backcolor)
{
    attrib = (backcolor << 4) | (forecolor & 0x0F);
f0101d15:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
f0101d1a:	0f b6 54 24 04       	movzbl 0x4(%esp),%edx
f0101d1f:	c1 e0 04             	shl    $0x4,%eax
f0101d22:	83 e2 0f             	and    $0xf,%edx
f0101d25:	09 d0                	or     %edx,%eax
f0101d27:	a3 40 73 10 f0       	mov    %eax,0xf0107340
}
f0101d2c:	c3                   	ret    

f0101d2d <init_video>:

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
f0101d2d:	83 ec 0c             	sub    $0xc,%esp
    textmemptr = (unsigned short *)0xB8000;
f0101d30:	c7 05 c0 76 11 f0 00 	movl   $0xb8000,0xf01176c0
f0101d37:	80 0b 00 
    sys_cls();
}
f0101d3a:	83 c4 0c             	add    $0xc,%esp

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
    textmemptr = (unsigned short *)0xB8000;
    sys_cls();
f0101d3d:	e9 87 fe ff ff       	jmp    f0101bc9 <sys_cls>
	...

f0101d44 <page_fault_handler>:
	trap_dispatch(tf);
}


void page_fault_handler(struct Trapframe *tf)
{
f0101d44:	83 ec 14             	sub    $0x14,%esp

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0101d47:	0f 20 d0             	mov    %cr2,%eax
    printk("Page fault @ %p\n", rcr2());
f0101d4a:	50                   	push   %eax
f0101d4b:	68 10 57 10 f0       	push   $0xf0105710
f0101d50:	e8 7b 04 00 00       	call   f01021d0 <printk>
f0101d55:	83 c4 10             	add    $0x10,%esp
f0101d58:	eb fe                	jmp    f0101d58 <page_fault_handler+0x14>

f0101d5a <print_regs>:
		printk("  ss   0x----%04x\n", tf->tf_ss);
	}
}
void
print_regs(struct PushRegs *regs)
{
f0101d5a:	53                   	push   %ebx
f0101d5b:	83 ec 10             	sub    $0x10,%esp
f0101d5e:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	printk("  edi  0x%08x\n", regs->reg_edi);
f0101d62:	ff 33                	pushl  (%ebx)
f0101d64:	68 21 57 10 f0       	push   $0xf0105721
f0101d69:	e8 62 04 00 00       	call   f01021d0 <printk>
	printk("  esi  0x%08x\n", regs->reg_esi);
f0101d6e:	58                   	pop    %eax
f0101d6f:	5a                   	pop    %edx
f0101d70:	ff 73 04             	pushl  0x4(%ebx)
f0101d73:	68 30 57 10 f0       	push   $0xf0105730
f0101d78:	e8 53 04 00 00       	call   f01021d0 <printk>
	printk("  ebp  0x%08x\n", regs->reg_ebp);
f0101d7d:	5a                   	pop    %edx
f0101d7e:	59                   	pop    %ecx
f0101d7f:	ff 73 08             	pushl  0x8(%ebx)
f0101d82:	68 3f 57 10 f0       	push   $0xf010573f
f0101d87:	e8 44 04 00 00       	call   f01021d0 <printk>
	printk("  oesp 0x%08x\n", regs->reg_oesp);
f0101d8c:	59                   	pop    %ecx
f0101d8d:	58                   	pop    %eax
f0101d8e:	ff 73 0c             	pushl  0xc(%ebx)
f0101d91:	68 4e 57 10 f0       	push   $0xf010574e
f0101d96:	e8 35 04 00 00       	call   f01021d0 <printk>
	printk("  ebx  0x%08x\n", regs->reg_ebx);
f0101d9b:	58                   	pop    %eax
f0101d9c:	5a                   	pop    %edx
f0101d9d:	ff 73 10             	pushl  0x10(%ebx)
f0101da0:	68 5d 57 10 f0       	push   $0xf010575d
f0101da5:	e8 26 04 00 00       	call   f01021d0 <printk>
	printk("  edx  0x%08x\n", regs->reg_edx);
f0101daa:	5a                   	pop    %edx
f0101dab:	59                   	pop    %ecx
f0101dac:	ff 73 14             	pushl  0x14(%ebx)
f0101daf:	68 6c 57 10 f0       	push   $0xf010576c
f0101db4:	e8 17 04 00 00       	call   f01021d0 <printk>
	printk("  ecx  0x%08x\n", regs->reg_ecx);
f0101db9:	59                   	pop    %ecx
f0101dba:	58                   	pop    %eax
f0101dbb:	ff 73 18             	pushl  0x18(%ebx)
f0101dbe:	68 7b 57 10 f0       	push   $0xf010577b
f0101dc3:	e8 08 04 00 00       	call   f01021d0 <printk>
	printk("  eax  0x%08x\n", regs->reg_eax);
f0101dc8:	58                   	pop    %eax
f0101dc9:	5a                   	pop    %edx
f0101dca:	ff 73 1c             	pushl  0x1c(%ebx)
f0101dcd:	68 8a 57 10 f0       	push   $0xf010578a
f0101dd2:	e8 f9 03 00 00       	call   f01021d0 <printk>
}
f0101dd7:	83 c4 18             	add    $0x18,%esp
f0101dda:	5b                   	pop    %ebx
f0101ddb:	c3                   	ret    

f0101ddc <print_trapframe>:
	return "(unknown trap)";
}

void
print_trapframe(struct Trapframe *tf)
{
f0101ddc:	56                   	push   %esi
f0101ddd:	53                   	push   %ebx
f0101dde:	83 ec 0c             	sub    $0xc,%esp
f0101de1:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	printk("TRAP frame at %p \n", tf);
f0101de5:	53                   	push   %ebx
f0101de6:	68 f5 57 10 f0       	push   $0xf01057f5
f0101deb:	e8 e0 03 00 00       	call   f01021d0 <printk>
	print_regs(&tf->tf_regs);
f0101df0:	89 1c 24             	mov    %ebx,(%esp)
f0101df3:	e8 62 ff ff ff       	call   f0101d5a <print_regs>
	printk("  es   0x----%04x\n", tf->tf_es);
f0101df8:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0101dfc:	5a                   	pop    %edx
f0101dfd:	59                   	pop    %ecx
f0101dfe:	50                   	push   %eax
f0101dff:	68 08 58 10 f0       	push   $0xf0105808
f0101e04:	e8 c7 03 00 00       	call   f01021d0 <printk>
	printk("  ds   0x----%04x\n", tf->tf_ds);
f0101e09:	5e                   	pop    %esi
f0101e0a:	58                   	pop    %eax
f0101e0b:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0101e0f:	50                   	push   %eax
f0101e10:	68 1b 58 10 f0       	push   $0xf010581b
f0101e15:	e8 b6 03 00 00       	call   f01021d0 <printk>
	printk("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0101e1a:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0101e1d:	83 c4 10             	add    $0x10,%esp
f0101e20:	83 f8 13             	cmp    $0x13,%eax
f0101e23:	77 09                	ja     f0101e2e <print_trapframe+0x52>
		return excnames[trapno];
f0101e25:	8b 14 85 4c 5a 10 f0 	mov    -0xfefa5b4(,%eax,4),%edx
f0101e2c:	eb 1d                	jmp    f0101e4b <print_trapframe+0x6f>
	if (trapno == T_SYSCALL)
f0101e2e:	83 f8 30             	cmp    $0x30,%eax
		return "System call";
f0101e31:	ba 99 57 10 f0       	mov    $0xf0105799,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
f0101e36:	74 13                	je     f0101e4b <print_trapframe+0x6f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0101e38:	8d 48 e0             	lea    -0x20(%eax),%ecx
		return "Hardware Interrupt";
f0101e3b:	ba a5 57 10 f0       	mov    $0xf01057a5,%edx
f0101e40:	83 f9 0f             	cmp    $0xf,%ecx
f0101e43:	b9 b8 57 10 f0       	mov    $0xf01057b8,%ecx
f0101e48:	0f 47 d1             	cmova  %ecx,%edx
{
	printk("TRAP frame at %p \n", tf);
	print_regs(&tf->tf_regs);
	printk("  es   0x----%04x\n", tf->tf_es);
	printk("  ds   0x----%04x\n", tf->tf_ds);
	printk("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0101e4b:	51                   	push   %ecx
f0101e4c:	52                   	push   %edx
f0101e4d:	50                   	push   %eax
f0101e4e:	68 2e 58 10 f0       	push   $0xf010582e
f0101e53:	e8 78 03 00 00       	call   f01021d0 <printk>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0101e58:	83 c4 10             	add    $0x10,%esp
f0101e5b:	3b 1d 18 4e 11 f0    	cmp    0xf0114e18,%ebx
f0101e61:	75 19                	jne    f0101e7c <print_trapframe+0xa0>
f0101e63:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0101e67:	75 13                	jne    f0101e7c <print_trapframe+0xa0>
f0101e69:	0f 20 d0             	mov    %cr2,%eax
		printk("  cr2  0x%08x\n", rcr2());
f0101e6c:	52                   	push   %edx
f0101e6d:	52                   	push   %edx
f0101e6e:	50                   	push   %eax
f0101e6f:	68 40 58 10 f0       	push   $0xf0105840
f0101e74:	e8 57 03 00 00       	call   f01021d0 <printk>
f0101e79:	83 c4 10             	add    $0x10,%esp
	printk("  err  0x%08x", tf->tf_err);
f0101e7c:	56                   	push   %esi
f0101e7d:	56                   	push   %esi
f0101e7e:	ff 73 2c             	pushl  0x2c(%ebx)
f0101e81:	68 4f 58 10 f0       	push   $0xf010584f
f0101e86:	e8 45 03 00 00       	call   f01021d0 <printk>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0101e8b:	83 c4 10             	add    $0x10,%esp
f0101e8e:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0101e92:	75 43                	jne    f0101ed7 <print_trapframe+0xfb>
		printk(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f0101e94:	8b 73 2c             	mov    0x2c(%ebx),%esi
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		printk(" [%s, %s, %s]\n",
f0101e97:	b8 d2 57 10 f0       	mov    $0xf01057d2,%eax
f0101e9c:	b9 c7 57 10 f0       	mov    $0xf01057c7,%ecx
f0101ea1:	ba de 57 10 f0       	mov    $0xf01057de,%edx
f0101ea6:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0101eac:	0f 44 c8             	cmove  %eax,%ecx
f0101eaf:	f7 c6 02 00 00 00    	test   $0x2,%esi
f0101eb5:	b8 e4 57 10 f0       	mov    $0xf01057e4,%eax
f0101eba:	0f 44 d0             	cmove  %eax,%edx
f0101ebd:	83 e6 04             	and    $0x4,%esi
f0101ec0:	51                   	push   %ecx
f0101ec1:	b8 e9 57 10 f0       	mov    $0xf01057e9,%eax
f0101ec6:	be ee 57 10 f0       	mov    $0xf01057ee,%esi
f0101ecb:	52                   	push   %edx
f0101ecc:	0f 44 c6             	cmove  %esi,%eax
f0101ecf:	50                   	push   %eax
f0101ed0:	68 5d 58 10 f0       	push   $0xf010585d
f0101ed5:	eb 08                	jmp    f0101edf <print_trapframe+0x103>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		printk("\n");
f0101ed7:	83 ec 0c             	sub    $0xc,%esp
f0101eda:	68 06 58 10 f0       	push   $0xf0105806
f0101edf:	e8 ec 02 00 00       	call   f01021d0 <printk>
f0101ee4:	5a                   	pop    %edx
f0101ee5:	59                   	pop    %ecx
	printk("  eip  0x%08x\n", tf->tf_eip);
f0101ee6:	ff 73 30             	pushl  0x30(%ebx)
f0101ee9:	68 6c 58 10 f0       	push   $0xf010586c
f0101eee:	e8 dd 02 00 00       	call   f01021d0 <printk>
	printk("  cs   0x----%04x\n", tf->tf_cs);
f0101ef3:	5e                   	pop    %esi
f0101ef4:	58                   	pop    %eax
f0101ef5:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0101ef9:	50                   	push   %eax
f0101efa:	68 7b 58 10 f0       	push   $0xf010587b
f0101eff:	e8 cc 02 00 00       	call   f01021d0 <printk>
	printk("  flag 0x%08x\n", tf->tf_eflags);
f0101f04:	5a                   	pop    %edx
f0101f05:	59                   	pop    %ecx
f0101f06:	ff 73 38             	pushl  0x38(%ebx)
f0101f09:	68 8e 58 10 f0       	push   $0xf010588e
f0101f0e:	e8 bd 02 00 00       	call   f01021d0 <printk>
	if ((tf->tf_cs & 3) != 0) {
f0101f13:	83 c4 10             	add    $0x10,%esp
f0101f16:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0101f1a:	74 23                	je     f0101f3f <print_trapframe+0x163>
		printk("  esp  0x%08x\n", tf->tf_esp);
f0101f1c:	50                   	push   %eax
f0101f1d:	50                   	push   %eax
f0101f1e:	ff 73 3c             	pushl  0x3c(%ebx)
f0101f21:	68 9d 58 10 f0       	push   $0xf010589d
f0101f26:	e8 a5 02 00 00       	call   f01021d0 <printk>
		printk("  ss   0x----%04x\n", tf->tf_ss);
f0101f2b:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0101f2f:	59                   	pop    %ecx
f0101f30:	5e                   	pop    %esi
f0101f31:	50                   	push   %eax
f0101f32:	68 ac 58 10 f0       	push   $0xf01058ac
f0101f37:	e8 94 02 00 00       	call   f01021d0 <printk>
f0101f3c:	83 c4 10             	add    $0x10,%esp
	}
}
f0101f3f:	83 c4 04             	add    $0x4,%esp
f0101f42:	5b                   	pop    %ebx
f0101f43:	5e                   	pop    %esi
f0101f44:	c3                   	ret    

f0101f45 <register_handler>:
	printk("  ecx  0x%08x\n", regs->reg_ecx);
	printk("  eax  0x%08x\n", regs->reg_eax);
}

void register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
{
f0101f45:	53                   	push   %ebx
f0101f46:	8b 4c 24 10          	mov    0x10(%esp),%ecx
f0101f4a:	8b 44 24 08          	mov    0x8(%esp),%eax
	if (trapno >= 0 && trapno < 256 && trap_entry != NULL)
f0101f4e:	85 c9                	test   %ecx,%ecx
f0101f50:	74 5a                	je     f0101fac <register_handler+0x67>
f0101f52:	3d ff 00 00 00       	cmp    $0xff,%eax
f0101f57:	77 53                	ja     f0101fac <register_handler+0x67>
	{
		trap_hnd[trapno] = hnd;
f0101f59:	8b 54 24 0c          	mov    0xc(%esp),%edx
		/* Set trap gate */
		SETGATE(idt[trapno], isTrap, GD_KT, trap_entry, dpl);
f0101f5d:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
f0101f62:	8b 5c 24 18          	mov    0x18(%esp),%ebx
f0101f66:	66 89 0c c5 18 42 11 	mov    %cx,-0xfeebde8(,%eax,8)
f0101f6d:	f0 

void register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
{
	if (trapno >= 0 && trapno < 256 && trap_entry != NULL)
	{
		trap_hnd[trapno] = hnd;
f0101f6e:	89 14 85 18 4a 11 f0 	mov    %edx,-0xfeeb5e8(,%eax,4)
		/* Set trap gate */
		SETGATE(idt[trapno], isTrap, GD_KT, trap_entry, dpl);
f0101f75:	19 d2                	sbb    %edx,%edx
f0101f77:	83 c2 0f             	add    $0xf,%edx
f0101f7a:	83 e3 03             	and    $0x3,%ebx
f0101f7d:	83 e2 0f             	and    $0xf,%edx
f0101f80:	c1 e3 05             	shl    $0x5,%ebx
f0101f83:	09 da                	or     %ebx,%edx
f0101f85:	83 ca 80             	or     $0xffffff80,%edx
f0101f88:	c1 e9 10             	shr    $0x10,%ecx
f0101f8b:	66 c7 04 c5 1a 42 11 	movw   $0x8,-0xfeebde6(,%eax,8)
f0101f92:	f0 08 00 
f0101f95:	c6 04 c5 1c 42 11 f0 	movb   $0x0,-0xfeebde4(,%eax,8)
f0101f9c:	00 
f0101f9d:	88 14 c5 1d 42 11 f0 	mov    %dl,-0xfeebde3(,%eax,8)
f0101fa4:	66 89 0c c5 1e 42 11 	mov    %cx,-0xfeebde2(,%eax,8)
f0101fab:	f0 
	}
}
f0101fac:	5b                   	pop    %ebx
f0101fad:	c3                   	ret    

f0101fae <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0101fae:	83 ec 10             	sub    $0x10,%esp
	__asm __volatile("movl %0,%%esp\n"
f0101fb1:	8b 64 24 14          	mov    0x14(%esp),%esp
f0101fb5:	61                   	popa   
f0101fb6:	07                   	pop    %es
f0101fb7:	1f                   	pop    %ds
f0101fb8:	83 c4 08             	add    $0x8,%esp
f0101fbb:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0101fbc:	68 bf 58 10 f0       	push   $0xf01058bf
f0101fc1:	68 83 00 00 00       	push   $0x83
f0101fc6:	68 cb 58 10 f0       	push   $0xf01058cb
f0101fcb:	e8 70 1c 00 00       	call   f0103c40 <_panic>

f0101fd0 <default_trap_handler>:
	panic("Unexpected trap!");
	
}

void default_trap_handler(struct Trapframe *tf)
{
f0101fd0:	57                   	push   %edi
f0101fd1:	56                   	push   %esi
f0101fd2:	83 ec 04             	sub    $0x4,%esp
f0101fd5:	8b 74 24 10          	mov    0x10(%esp),%esi
trap_dispatch(struct Trapframe *tf)
{
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0101fd9:	8b 46 28             	mov    0x28(%esi),%eax

void default_trap_handler(struct Trapframe *tf)
{
	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0101fdc:	89 35 18 4e 11 f0    	mov    %esi,0xf0114e18
trap_dispatch(struct Trapframe *tf)
{
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0101fe2:	83 f8 27             	cmp    $0x27,%eax
f0101fe5:	75 1b                	jne    f0102002 <default_trap_handler+0x32>
		printk("Spurious interrupt on irq 7\n");
f0101fe7:	83 ec 0c             	sub    $0xc,%esp
f0101fea:	68 d9 58 10 f0       	push   $0xf01058d9
f0101fef:	e8 dc 01 00 00       	call   f01021d0 <printk>
		print_trapframe(tf);
f0101ff4:	89 74 24 20          	mov    %esi,0x20(%esp)
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
f0101ff8:	83 c4 14             	add    $0x14,%esp
f0101ffb:	5e                   	pop    %esi
f0101ffc:	5f                   	pop    %edi
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		printk("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
f0101ffd:	e9 da fd ff ff       	jmp    f0101ddc <print_trapframe>
		return;
	}

	last_tf = tf;
	/* Lab3: Check the trap number and call the interrupt handler. */
	if (trap_hnd[tf->tf_trapno] != NULL)
f0102002:	83 3c 85 18 4a 11 f0 	cmpl   $0x0,-0xfeeb5e8(,%eax,4)
f0102009:	00 
f010200a:	74 3b                	je     f0102047 <default_trap_handler+0x77>
	{
	
		if ((tf->tf_cs & 3) == 3)
f010200c:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0102010:	83 e0 03             	and    $0x3,%eax
f0102013:	83 f8 03             	cmp    $0x3,%eax
f0102016:	75 13                	jne    f010202b <default_trap_handler+0x5b>
			// Trapped from user mode.
			extern Task *cur_task;

			// Disable interrupt first
			// Think: Why we disable interrupt here?
			__asm __volatile("cli");
f0102018:	fa                   	cli    

			// Copy trap frame (which is currently on the stack)
			// into 'cur_task->tf', so that running the environment
			// will restart at the trap point.
			cur_task->tf = *tf;
f0102019:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f010201e:	b9 11 00 00 00       	mov    $0x11,%ecx
f0102023:	8d 78 08             	lea    0x8(%eax),%edi
f0102026:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			tf = &(cur_task->tf);
f0102028:	8d 70 08             	lea    0x8(%eax),%esi
				
		}
		// Do ISR
		trap_hnd[tf->tf_trapno](tf);
f010202b:	8b 46 28             	mov    0x28(%esi),%eax
f010202e:	83 ec 0c             	sub    $0xc,%esp
f0102031:	56                   	push   %esi
f0102032:	ff 14 85 18 4a 11 f0 	call   *-0xfeeb5e8(,%eax,4)
		
		// Pop the kernel stack 
		env_pop_tf(tf);
f0102039:	89 74 24 20          	mov    %esi,0x20(%esp)
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
f010203d:	83 c4 14             	add    $0x14,%esp
f0102040:	5e                   	pop    %esi
f0102041:	5f                   	pop    %edi
		}
		// Do ISR
		trap_hnd[tf->tf_trapno](tf);
		
		// Pop the kernel stack 
		env_pop_tf(tf);
f0102042:	e9 67 ff ff ff       	jmp    f0101fae <env_pop_tf>
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0102047:	83 ec 0c             	sub    $0xc,%esp
f010204a:	56                   	push   %esi
f010204b:	e8 8c fd ff ff       	call   f0101ddc <print_trapframe>
	panic("Unexpected trap!");
f0102050:	83 c4 0c             	add    $0xc,%esp
f0102053:	68 f6 58 10 f0       	push   $0xf01058f6
f0102058:	68 b1 00 00 00       	push   $0xb1
f010205d:	68 cb 58 10 f0       	push   $0xf01058cb
f0102062:	e8 d9 1b 00 00       	call   f0103c40 <_panic>

f0102067 <trap_init>:
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
	{
		SETGATE(idt[i], 1, GD_KT, Default_ISR, 0);
f0102067:	b9 2c 21 10 f0       	mov    $0xf010212c,%ecx
void trap_init()
{
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
f010206c:	31 c0                	xor    %eax,%eax
	{
		SETGATE(idt[i], 1, GD_KT, Default_ISR, 0);
f010206e:	c1 e9 10             	shr    $0x10,%ecx
f0102071:	ba 2c 21 10 f0       	mov    $0xf010212c,%edx
f0102076:	66 89 14 c5 18 42 11 	mov    %dx,-0xfeebde8(,%eax,8)
f010207d:	f0 
f010207e:	66 c7 04 c5 1a 42 11 	movw   $0x8,-0xfeebde6(,%eax,8)
f0102085:	f0 08 00 
f0102088:	c6 04 c5 1c 42 11 f0 	movb   $0x0,-0xfeebde4(,%eax,8)
f010208f:	00 
f0102090:	c6 04 c5 1d 42 11 f0 	movb   $0x8f,-0xfeebde3(,%eax,8)
f0102097:	8f 
f0102098:	66 89 0c c5 1e 42 11 	mov    %cx,-0xfeebde2(,%eax,8)
f010209f:	f0 
		trap_hnd[i] = NULL;
f01020a0:	c7 04 85 18 4a 11 f0 	movl   $0x0,-0xfeeb5e8(,%eax,4)
f01020a7:	00 00 00 00 
void trap_init()
{
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
f01020ab:	40                   	inc    %eax
f01020ac:	3d 00 01 00 00       	cmp    $0x100,%eax
f01020b1:	75 c3                	jne    f0102076 <trap_init+0xf>
	//SETGATE(idt[T_SYSCALL],1,GD_KT, SYSCALL,0);	


  /* Using custom trap handler */
	extern void PGFLT();
  register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f01020b3:	6a 00                	push   $0x0
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f01020b5:	b8 48 21 10 f0       	mov    $0xf0102148,%eax
	//SETGATE(idt[T_SYSCALL],1,GD_KT, SYSCALL,0);	


  /* Using custom trap handler */
	extern void PGFLT();
  register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f01020ba:	6a 01                	push   $0x1
f01020bc:	68 54 21 10 f0       	push   $0xf0102154
f01020c1:	68 44 1d 10 f0       	push   $0xf0101d44
f01020c6:	6a 0e                	push   $0xe
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f01020c8:	66 a3 80 42 11 f0    	mov    %ax,0xf0114280
f01020ce:	c1 e8 10             	shr    $0x10,%eax
f01020d1:	66 a3 86 42 11 f0    	mov    %ax,0xf0114286
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);
f01020d7:	b8 4e 21 10 f0       	mov    $0xf010214e,%eax
f01020dc:	66 a3 78 42 11 f0    	mov    %ax,0xf0114278
f01020e2:	c1 e8 10             	shr    $0x10,%eax
f01020e5:	66 a3 7e 42 11 f0    	mov    %ax,0xf011427e
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f01020eb:	66 c7 05 82 42 11 f0 	movw   $0x8,0xf0114282
f01020f2:	08 00 
f01020f4:	c6 05 84 42 11 f0 00 	movb   $0x0,0xf0114284
f01020fb:	c6 05 85 42 11 f0 8f 	movb   $0x8f,0xf0114285
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);
f0102102:	66 c7 05 7a 42 11 f0 	movw   $0x8,0xf011427a
f0102109:	08 00 
f010210b:	c6 05 7c 42 11 f0 00 	movb   $0x0,0xf011427c
f0102112:	c6 05 7d 42 11 f0 8f 	movb   $0x8f,0xf011427d
	//SETGATE(idt[T_SYSCALL],1,GD_KT, SYSCALL,0);	


  /* Using custom trap handler */
	extern void PGFLT();
  register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f0102119:	e8 27 fe ff ff       	call   f0101f45 <register_handler>
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f010211e:	b8 44 73 10 f0       	mov    $0xf0107344,%eax
f0102123:	0f 01 18             	lidtl  (%eax)
f0102126:	83 c4 14             	add    $0x14,%esp

	lidt(&idt_pd);
}
f0102129:	c3                   	ret    
	...

f010212c <Default_ISR>:
	jmp _alltraps

.text

/* ISRs */
TRAPHANDLER_NOEC(Default_ISR, T_DEFAULT)
f010212c:	6a 00                	push   $0x0
f010212e:	68 f4 01 00 00       	push   $0x1f4
f0102133:	eb 25                	jmp    f010215a <_alltraps>
f0102135:	90                   	nop

f0102136 <KBD_Input>:
TRAPHANDLER_NOEC(KBD_Input, IRQ_OFFSET+IRQ_KBD)
f0102136:	6a 00                	push   $0x0
f0102138:	6a 21                	push   $0x21
f010213a:	eb 1e                	jmp    f010215a <_alltraps>

f010213c <TIM_ISR>:
TRAPHANDLER_NOEC(TIM_ISR, IRQ_OFFSET+IRQ_TIMER)
f010213c:	6a 00                	push   $0x0
f010213e:	6a 20                	push   $0x20
f0102140:	eb 18                	jmp    f010215a <_alltraps>

f0102142 <SYSCALL>:

// TODO: Lab 5
// Please add interface of system call
TRAPHANDLER_NOEC(SYSCALL,T_SYSCALL)
f0102142:	6a 00                	push   $0x0
f0102144:	6a 30                	push   $0x30
f0102146:	eb 12                	jmp    f010215a <_alltraps>

f0102148 <GPFLT>:
TRAPHANDLER_NOEC(GPFLT, T_GPFLT)
f0102148:	6a 00                	push   $0x0
f010214a:	6a 0d                	push   $0xd
f010214c:	eb 0c                	jmp    f010215a <_alltraps>

f010214e <STACK_ISR>:
TRAPHANDLER_NOEC(STACK_ISR, T_STACK)
f010214e:	6a 00                	push   $0x0
f0102150:	6a 0c                	push   $0xc
f0102152:	eb 06                	jmp    f010215a <_alltraps>

f0102154 <PGFLT>:
TRAPHANDLER_NOEC(PGFLT, T_PGFLT)
f0102154:	6a 00                	push   $0x0
f0102156:	6a 0e                	push   $0xe
f0102158:	eb 00                	jmp    f010215a <_alltraps>

f010215a <_alltraps>:
_alltraps:
	/* Lab3: Push the registers into stack( fill the Trapframe structure )
	 * You can reference the http://www.osdever.net/bkerndev/Docs/isrs.htm
	 * After stack parpared, just "call default_trap_handler".
	 */
	pushl %ds
f010215a:	1e                   	push   %ds
	pushl %es
f010215b:	06                   	push   %es
	pushal # Push all general register into stack, it maps to Trapframe.tf_regs
f010215c:	60                   	pusha  
	/* Load the Kernel Data Segment descriptor */
	mov $(GD_KD), %ax
f010215d:	66 b8 10 00          	mov    $0x10,%ax
	mov %ax, %ds
f0102161:	8e d8                	mov    %eax,%ds
	mov %ax, %es
f0102163:	8e c0                	mov    %eax,%es
	mov %ax, %fs
f0102165:	8e e0                	mov    %eax,%fs
	mov %ax, %gs
f0102167:	8e e8                	mov    %eax,%gs
	
	pushl %esp # Pass a pointer to the Trapframe as an argument to default_trap_handler()
f0102169:	54                   	push   %esp
	call default_trap_handler
f010216a:	e8 61 fe ff ff       	call   f0101fd0 <default_trap_handler>
	
	/* Restore fs and gs to user data segmemnt */
	push %ax
f010216f:	66 50                	push   %ax
	mov $(GD_UD), %ax
f0102171:	66 b8 20 00          	mov    $0x20,%ax
	or $3, %ax
f0102175:	66 83 c8 03          	or     $0x3,%ax
	mov %ax, %fs
f0102179:	8e e0                	mov    %eax,%fs
	mov %ax, %gs
f010217b:	8e e8                	mov    %eax,%gs
	pop %ax 
f010217d:	66 58                	pop    %ax
	add $4, %esp
f010217f:	83 c4 04             	add    $0x4,%esp

f0102182 <trapret>:

# Return falls through to trapret...
.globl trapret
trapret:
  popal
f0102182:	61                   	popa   
  popl %es
f0102183:	07                   	pop    %es
  popl %ds
f0102184:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
f0102185:	83 c4 08             	add    $0x8,%esp
  iret
f0102188:	cf                   	iret   
f0102189:	00 00                	add    %al,(%eax)
	...

f010218c <putch>:
#include <inc/types.h>
#include <inc/stdio.h>

static void
putch(int ch, int *cnt)
{
f010218c:	53                   	push   %ebx
f010218d:	83 ec 14             	sub    $0x14,%esp
	k_putch(ch); // in kernel/screen.c
f0102190:	0f b6 44 24 1c       	movzbl 0x1c(%esp),%eax
#include <inc/types.h>
#include <inc/stdio.h>

static void
putch(int ch, int *cnt)
{
f0102195:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	k_putch(ch); // in kernel/screen.c
f0102199:	50                   	push   %eax
f010219a:	e8 80 fa ff ff       	call   f0101c1f <k_putch>
	(*cnt)++;
f010219f:	ff 03                	incl   (%ebx)
}
f01021a1:	83 c4 18             	add    $0x18,%esp
f01021a4:	5b                   	pop    %ebx
f01021a5:	c3                   	ret    

f01021a6 <vprintk>:

int
vprintk(const char *fmt, va_list ap)
{
f01021a6:	83 ec 1c             	sub    $0x1c,%esp
	int cnt = 0;
f01021a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01021b0:	00 

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01021b1:	ff 74 24 24          	pushl  0x24(%esp)
f01021b5:	ff 74 24 24          	pushl  0x24(%esp)
f01021b9:	8d 44 24 14          	lea    0x14(%esp),%eax
f01021bd:	50                   	push   %eax
f01021be:	68 8c 21 10 f0       	push   $0xf010218c
f01021c3:	e8 a7 e4 ff ff       	call   f010066f <vprintfmt>
	return cnt;
}
f01021c8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f01021cc:	83 c4 2c             	add    $0x2c,%esp
f01021cf:	c3                   	ret    

f01021d0 <printk>:

int
printk(const char *fmt, ...)
{
f01021d0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01021d3:	8d 44 24 14          	lea    0x14(%esp),%eax
	cnt = vprintk(fmt, ap);
f01021d7:	52                   	push   %edx
f01021d8:	52                   	push   %edx
f01021d9:	50                   	push   %eax
f01021da:	ff 74 24 1c          	pushl  0x1c(%esp)
f01021de:	e8 c3 ff ff ff       	call   f01021a6 <vprintk>
	va_end(ap);

	return cnt;
}
f01021e3:	83 c4 1c             	add    $0x1c,%esp
f01021e6:	c3                   	ret    
	...

f01021e8 <page2pa>:
}

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01021e8:	2b 05 d0 76 11 f0    	sub    0xf01176d0,%eax
f01021ee:	c1 f8 03             	sar    $0x3,%eax
f01021f1:	c1 e0 0c             	shl    $0xc,%eax
}
f01021f4:	c3                   	ret    

f01021f5 <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f01021f5:	83 3d 20 4e 11 f0 00 	cmpl   $0x0,0xf0114e20
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f01021fc:	89 c2                	mov    %eax,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f01021fe:	75 11                	jne    f0102211 <boot_alloc+0x1c>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0102200:	b9 37 8c 11 f0       	mov    $0xf0118c37,%ecx
f0102205:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010220b:	89 0d 20 4e 11 f0    	mov    %ecx,0xf0114e20
	}

	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
    if (n == 0)
f0102211:	85 d2                	test   %edx,%edx
f0102213:	a1 20 4e 11 f0       	mov    0xf0114e20,%eax
f0102218:	74 15                	je     f010222f <boot_alloc+0x3a>
        return nextfree;
    else if (n > 0)
    {
        result = nextfree;
        nextfree += ROUNDUP(n, PGSIZE);
f010221a:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0102220:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102226:	8d 14 10             	lea    (%eax,%edx,1),%edx
f0102229:	89 15 20 4e 11 f0    	mov    %edx,0xf0114e20
    }

	return result;
}
f010222f:	c3                   	ret    

f0102230 <_kaddr>:
	return (physaddr_t)kva - KERNBASE;
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0102230:	53                   	push   %ebx
	if (PGNUM(pa) >= npages)
f0102231:	89 cb                	mov    %ecx,%ebx
	return (physaddr_t)kva - KERNBASE;
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0102233:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
f0102236:	c1 eb 0c             	shr    $0xc,%ebx
f0102239:	3b 1d c4 76 11 f0    	cmp    0xf01176c4,%ebx
f010223f:	72 0d                	jb     f010224e <_kaddr+0x1e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102241:	51                   	push   %ecx
f0102242:	68 9c 5a 10 f0       	push   $0xf0105a9c
f0102247:	52                   	push   %edx
f0102248:	50                   	push   %eax
f0102249:	e8 f2 19 00 00       	call   f0103c40 <_panic>
	return (void *)(pa + KERNBASE);
f010224e:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0102254:	83 c4 08             	add    $0x8,%esp
f0102257:	5b                   	pop    %ebx
f0102258:	c3                   	ret    

f0102259 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0102259:	83 ec 0c             	sub    $0xc,%esp
	return KADDR(page2pa(pp));
f010225c:	e8 87 ff ff ff       	call   f01021e8 <page2pa>
f0102261:	ba 55 00 00 00       	mov    $0x55,%edx
}
f0102266:	83 c4 0c             	add    $0xc,%esp
}

static inline void*
page2kva(struct PageInfo *pp)
{
	return KADDR(page2pa(pp));
f0102269:	89 c1                	mov    %eax,%ecx
f010226b:	b8 bf 5a 10 f0       	mov    $0xf0105abf,%eax
f0102270:	eb be                	jmp    f0102230 <_kaddr>

f0102272 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0102272:	56                   	push   %esi
f0102273:	89 d6                	mov    %edx,%esi
f0102275:	53                   	push   %ebx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0102276:	83 cb ff             	or     $0xffffffff,%ebx
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0102279:	c1 ea 16             	shr    $0x16,%edx
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f010227c:	83 ec 04             	sub    $0x4,%esp
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
f010227f:	8b 0c 90             	mov    (%eax,%edx,4),%ecx
f0102282:	f6 c1 01             	test   $0x1,%cl
f0102285:	74 2e                	je     f01022b5 <check_va2pa+0x43>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0102287:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010228d:	ba 54 03 00 00       	mov    $0x354,%edx
f0102292:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
f0102297:	e8 94 ff ff ff       	call   f0102230 <_kaddr>
	if (!(p[PTX(va)] & PTE_P))
f010229c:	c1 ee 0c             	shr    $0xc,%esi
f010229f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f01022a5:	8b 04 b0             	mov    (%eax,%esi,4),%eax
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f01022a8:	89 c2                	mov    %eax,%edx
f01022aa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01022b0:	a8 01                	test   $0x1,%al
f01022b2:	0f 45 da             	cmovne %edx,%ebx
}
f01022b5:	89 d8                	mov    %ebx,%eax
f01022b7:	83 c4 04             	add    $0x4,%esp
f01022ba:	5b                   	pop    %ebx
f01022bb:	5e                   	pop    %esi
f01022bc:	c3                   	ret    

f01022bd <pa2page>:
	return (pp - pages) << PGSHIFT;
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
f01022bd:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f01022c0:	c1 e8 0c             	shr    $0xc,%eax
f01022c3:	3b 05 c4 76 11 f0    	cmp    0xf01176c4,%eax
f01022c9:	72 12                	jb     f01022dd <pa2page+0x20>
		panic("pa2page called with invalid pa");
f01022cb:	50                   	push   %eax
f01022cc:	68 db 5a 10 f0       	push   $0xf0105adb
f01022d1:	6a 4e                	push   $0x4e
f01022d3:	68 bf 5a 10 f0       	push   $0xf0105abf
f01022d8:	e8 63 19 00 00       	call   f0103c40 <_panic>
	return &pages[PGNUM(pa)];
f01022dd:	c1 e0 03             	shl    $0x3,%eax
f01022e0:	03 05 d0 76 11 f0    	add    0xf01176d0,%eax
}
f01022e6:	83 c4 0c             	add    $0xc,%esp
f01022e9:	c3                   	ret    

f01022ea <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f01022ea:	55                   	push   %ebp
f01022eb:	57                   	push   %edi
f01022ec:	56                   	push   %esi
f01022ed:	53                   	push   %ebx
f01022ee:	83 ec 1c             	sub    $0x1c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f01022f1:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01022f7:	3c 01                	cmp    $0x1,%al
f01022f9:	19 f6                	sbb    %esi,%esi
f01022fb:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f0102301:	46                   	inc    %esi
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f0102302:	85 db                	test   %ebx,%ebx
f0102304:	75 10                	jne    f0102316 <check_page_free_list+0x2c>
		panic("'page_free_list' is a null pointer!");
f0102306:	51                   	push   %ecx
f0102307:	68 fa 5a 10 f0       	push   $0xf0105afa
f010230c:	68 92 02 00 00       	push   $0x292
f0102311:	e9 b6 00 00 00       	jmp    f01023cc <check_page_free_list+0xe2>

	if (only_low_memory) {
f0102316:	84 c0                	test   %al,%al
f0102318:	74 4b                	je     f0102365 <check_page_free_list+0x7b>
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010231a:	8d 44 24 0c          	lea    0xc(%esp),%eax
f010231e:	89 04 24             	mov    %eax,(%esp)
f0102321:	8d 44 24 08          	lea    0x8(%esp),%eax
f0102325:	89 44 24 04          	mov    %eax,0x4(%esp)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0102329:	89 d8                	mov    %ebx,%eax
f010232b:	e8 b8 fe ff ff       	call   f01021e8 <page2pa>
f0102330:	c1 e8 16             	shr    $0x16,%eax
f0102333:	39 f0                	cmp    %esi,%eax
f0102335:	0f 93 c0             	setae  %al
f0102338:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f010233b:	8b 14 84             	mov    (%esp,%eax,4),%edx
f010233e:	89 1a                	mov    %ebx,(%edx)
			tp[pagetype] = &pp->pp_link;
f0102340:	89 1c 84             	mov    %ebx,(%esp,%eax,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0102343:	8b 1b                	mov    (%ebx),%ebx
f0102345:	85 db                	test   %ebx,%ebx
f0102347:	75 e0                	jne    f0102329 <check_page_free_list+0x3f>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f0102349:	8b 44 24 04          	mov    0x4(%esp),%eax
f010234d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0102353:	8b 04 24             	mov    (%esp),%eax
f0102356:	8b 54 24 08          	mov    0x8(%esp),%edx
f010235a:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f010235c:	8b 44 24 0c          	mov    0xc(%esp),%eax
f0102360:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102365:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
f010236b:	eb 2b                	jmp    f0102398 <check_page_free_list+0xae>
		if (PDX(page2pa(pp)) < pdx_limit)
f010236d:	89 d8                	mov    %ebx,%eax
f010236f:	e8 74 fe ff ff       	call   f01021e8 <page2pa>
f0102374:	c1 e8 16             	shr    $0x16,%eax
f0102377:	39 f0                	cmp    %esi,%eax
f0102379:	73 1b                	jae    f0102396 <check_page_free_list+0xac>
			memset(page2kva(pp), 0x97, 128);
f010237b:	89 d8                	mov    %ebx,%eax
f010237d:	e8 d7 fe ff ff       	call   f0102259 <page2kva>
f0102382:	52                   	push   %edx
f0102383:	68 80 00 00 00       	push   $0x80
f0102388:	68 97 00 00 00       	push   $0x97
f010238d:	50                   	push   %eax
f010238e:	e8 3c de ff ff       	call   f01001cf <memset>
f0102393:	83 c4 10             	add    $0x10,%esp
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102396:	8b 1b                	mov    (%ebx),%ebx
f0102398:	85 db                	test   %ebx,%ebx
f010239a:	75 d1                	jne    f010236d <check_page_free_list+0x83>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f010239c:	31 c0                	xor    %eax,%eax
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f010239e:	31 f6                	xor    %esi,%esi
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f01023a0:	e8 50 fe ff ff       	call   f01021f5 <boot_alloc>
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f01023a5:	31 ff                	xor    %edi,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01023a7:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f01023ad:	89 c5                	mov    %eax,%ebp
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01023af:	e9 ff 00 00 00       	jmp    f01024b3 <check_page_free_list+0x1c9>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f01023b4:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
f01023b9:	39 c3                	cmp    %eax,%ebx
f01023bb:	73 19                	jae    f01023d6 <check_page_free_list+0xec>
f01023bd:	68 1e 5b 10 f0       	push   $0xf0105b1e
f01023c2:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01023c7:	68 ac 02 00 00       	push   $0x2ac
f01023cc:	68 ce 5a 10 f0       	push   $0xf0105ace
f01023d1:	e8 6a 18 00 00       	call   f0103c40 <_panic>
		assert(pp < pages + npages);
f01023d6:	8b 15 c4 76 11 f0    	mov    0xf01176c4,%edx
f01023dc:	8d 14 d0             	lea    (%eax,%edx,8),%edx
f01023df:	39 d3                	cmp    %edx,%ebx
f01023e1:	72 11                	jb     f01023f4 <check_page_free_list+0x10a>
f01023e3:	68 3f 5b 10 f0       	push   $0xf0105b3f
f01023e8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01023ed:	68 ad 02 00 00       	push   $0x2ad
f01023f2:	eb d8                	jmp    f01023cc <check_page_free_list+0xe2>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01023f4:	89 da                	mov    %ebx,%edx
f01023f6:	29 c2                	sub    %eax,%edx
f01023f8:	89 d0                	mov    %edx,%eax
f01023fa:	a8 07                	test   $0x7,%al
f01023fc:	74 11                	je     f010240f <check_page_free_list+0x125>
f01023fe:	68 53 5b 10 f0       	push   $0xf0105b53
f0102403:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102408:	68 ae 02 00 00       	push   $0x2ae
f010240d:	eb bd                	jmp    f01023cc <check_page_free_list+0xe2>

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f010240f:	89 d8                	mov    %ebx,%eax
f0102411:	e8 d2 fd ff ff       	call   f01021e8 <page2pa>
f0102416:	85 c0                	test   %eax,%eax
f0102418:	75 11                	jne    f010242b <check_page_free_list+0x141>
f010241a:	68 85 5b 10 f0       	push   $0xf0105b85
f010241f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102424:	68 b1 02 00 00       	push   $0x2b1
f0102429:	eb a1                	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) != IOPHYSMEM);
f010242b:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0102430:	75 11                	jne    f0102443 <check_page_free_list+0x159>
f0102432:	68 96 5b 10 f0       	push   $0xf0105b96
f0102437:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010243c:	68 b2 02 00 00       	push   $0x2b2
f0102441:	eb 89                	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0102443:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0102448:	75 14                	jne    f010245e <check_page_free_list+0x174>
f010244a:	68 af 5b 10 f0       	push   $0xf0105baf
f010244f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102454:	68 b3 02 00 00       	push   $0x2b3
f0102459:	e9 6e ff ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) != EXTPHYSMEM);
f010245e:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0102463:	75 14                	jne    f0102479 <check_page_free_list+0x18f>
f0102465:	68 d2 5b 10 f0       	push   $0xf0105bd2
f010246a:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010246f:	68 b4 02 00 00       	push   $0x2b4
f0102474:	e9 53 ff ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0102479:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f010247e:	76 1f                	jbe    f010249f <check_page_free_list+0x1b5>
f0102480:	89 d8                	mov    %ebx,%eax
f0102482:	e8 d2 fd ff ff       	call   f0102259 <page2kva>
f0102487:	39 e8                	cmp    %ebp,%eax
f0102489:	73 14                	jae    f010249f <check_page_free_list+0x1b5>
f010248b:	68 ec 5b 10 f0       	push   $0xf0105bec
f0102490:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102495:	68 b5 02 00 00       	push   $0x2b5
f010249a:	e9 2d ff ff ff       	jmp    f01023cc <check_page_free_list+0xe2>

		if (page2pa(pp) < EXTPHYSMEM)
f010249f:	89 d8                	mov    %ebx,%eax
f01024a1:	e8 42 fd ff ff       	call   f01021e8 <page2pa>
f01024a6:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01024ab:	77 03                	ja     f01024b0 <check_page_free_list+0x1c6>
			++nfree_basemem;
f01024ad:	47                   	inc    %edi
f01024ae:	eb 01                	jmp    f01024b1 <check_page_free_list+0x1c7>
		else
			++nfree_extmem;
f01024b0:	46                   	inc    %esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01024b1:	8b 1b                	mov    (%ebx),%ebx
f01024b3:	85 db                	test   %ebx,%ebx
f01024b5:	0f 85 f9 fe ff ff    	jne    f01023b4 <check_page_free_list+0xca>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f01024bb:	85 ff                	test   %edi,%edi
f01024bd:	75 14                	jne    f01024d3 <check_page_free_list+0x1e9>
f01024bf:	68 31 5c 10 f0       	push   $0xf0105c31
f01024c4:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01024c9:	68 bd 02 00 00       	push   $0x2bd
f01024ce:	e9 f9 fe ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
	assert(nfree_extmem > 0);
f01024d3:	85 f6                	test   %esi,%esi
f01024d5:	75 14                	jne    f01024eb <check_page_free_list+0x201>
f01024d7:	68 43 5c 10 f0       	push   $0xf0105c43
f01024dc:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01024e1:	68 be 02 00 00       	push   $0x2be
f01024e6:	e9 e1 fe ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
	printk("check_page_free_list() succeeded!\n");
f01024eb:	83 ec 0c             	sub    $0xc,%esp
f01024ee:	68 54 5c 10 f0       	push   $0xf0105c54
f01024f3:	e8 d8 fc ff ff       	call   f01021d0 <printk>
}
f01024f8:	83 c4 2c             	add    $0x2c,%esp
f01024fb:	5b                   	pop    %ebx
f01024fc:	5e                   	pop    %esi
f01024fd:	5f                   	pop    %edi
f01024fe:	5d                   	pop    %ebp
f01024ff:	c3                   	ret    

f0102500 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0102500:	56                   	push   %esi
f0102501:	53                   	push   %ebx
f0102502:	89 c3                	mov    %eax,%ebx
f0102504:	83 ec 10             	sub    $0x10,%esp
  return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0102507:	43                   	inc    %ebx
f0102508:	50                   	push   %eax
f0102509:	e8 b6 17 00 00       	call   f0103cc4 <mc146818_read>
f010250e:	89 1c 24             	mov    %ebx,(%esp)
f0102511:	89 c6                	mov    %eax,%esi
f0102513:	e8 ac 17 00 00       	call   f0103cc4 <mc146818_read>
}
f0102518:	83 c4 14             	add    $0x14,%esp
f010251b:	5b                   	pop    %ebx
// --------------------------------------------------------------

static int
nvram_read(int r)
{
  return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010251c:	c1 e0 08             	shl    $0x8,%eax
f010251f:	09 f0                	or     %esi,%eax
}
f0102521:	5e                   	pop    %esi
f0102522:	c3                   	ret    

f0102523 <_paddr.clone.0>:

void		check();
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
f0102523:	83 ec 0c             	sub    $0xc,%esp
{
	if ((uint32_t)kva < KERNBASE)
f0102526:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010252c:	77 11                	ja     f010253f <_paddr.clone.0+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010252e:	52                   	push   %edx
f010252f:	68 c2 54 10 f0       	push   $0xf01054c2
f0102534:	50                   	push   %eax
f0102535:	68 ce 5a 10 f0       	push   $0xf0105ace
f010253a:	e8 01 17 00 00       	call   f0103c40 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010253f:	8d 82 00 00 00 10    	lea    0x10000000(%edx),%eax
}
f0102545:	83 c4 0c             	add    $0xc,%esp
f0102548:	c3                   	ret    

f0102549 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0102549:	56                   	push   %esi
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	
    /* TODO */
	size_t i;
	for (i = 0; i < npages; i++) {
f010254a:	31 f6                	xor    %esi,%esi
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f010254c:	53                   	push   %ebx
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	
    /* TODO */
	size_t i;
	for (i = 0; i < npages; i++) {
f010254d:	31 db                	xor    %ebx,%ebx
f010254f:	eb 6a                	jmp    f01025bb <page_init+0x72>
	
		if(i == 0)
f0102551:	85 db                	test   %ebx,%ebx
f0102553:	75 07                	jne    f010255c <page_init+0x13>
		{
			pages[i].pp_ref = 1;
f0102555:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
f010255a:	eb 12                	jmp    f010256e <page_init+0x25>
			pages[i].pp_link = NULL;
		}
		else if(i >= PGNUM(IOPHYSMEM) && i < PGNUM(EXTPHYSMEM))
f010255c:	8d 83 60 ff ff ff    	lea    -0xa0(%ebx),%eax
f0102562:	83 f8 5f             	cmp    $0x5f,%eax
f0102565:	77 15                	ja     f010257c <page_init+0x33>
		{
			pages[i].pp_ref = 1;
f0102567:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
f010256c:	01 f0                	add    %esi,%eax
f010256e:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0102574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010257a:	eb 3b                	jmp    f01025b7 <page_init+0x6e>
		}
		else if(i >= PGNUM(EXTPHYSMEM)&& i < PGNUM((uint32_t)boot_alloc(0)-KERNBASE))
f010257c:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0102582:	76 13                	jbe    f0102597 <page_init+0x4e>
f0102584:	31 c0                	xor    %eax,%eax
f0102586:	e8 6a fc ff ff       	call   f01021f5 <boot_alloc>
f010258b:	05 00 00 00 10       	add    $0x10000000,%eax
f0102590:	c1 e8 0c             	shr    $0xc,%eax
f0102593:	39 c3                	cmp    %eax,%ebx
f0102595:	72 d0                	jb     f0102567 <page_init+0x1e>
			pages[i].pp_ref = 1;
			pages[i].pp_link = NULL;
		}
		else
		{
			pages[i].pp_ref = 0;
f0102597:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
			pages[i].pp_link = page_free_list;
f010259c:	8b 15 1c 4e 11 f0    	mov    0xf0114e1c,%edx
			pages[i].pp_ref = 1;
			pages[i].pp_link = NULL;
		}
		else
		{
			pages[i].pp_ref = 0;
f01025a2:	01 f0                	add    %esi,%eax
			pages[i].pp_link = page_free_list;
f01025a4:	89 10                	mov    %edx,(%eax)
			page_free_list = &pages[i];
			num_free_pages++;
f01025a6:	ff 05 cc 76 11 f0    	incl   0xf01176cc
			pages[i].pp_ref = 1;
			pages[i].pp_link = NULL;
		}
		else
		{
			pages[i].pp_ref = 0;
f01025ac:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
			pages[i].pp_link = page_free_list;
			page_free_list = &pages[i];
f01025b2:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	
    /* TODO */
	size_t i;
	for (i = 0; i < npages; i++) {
f01025b7:	43                   	inc    %ebx
f01025b8:	83 c6 08             	add    $0x8,%esi
f01025bb:	3b 1d c4 76 11 f0    	cmp    0xf01176c4,%ebx
f01025c1:	72 8e                	jb     f0102551 <page_init+0x8>
			page_free_list = &pages[i];
			num_free_pages++;
	
		}
    	}
}
f01025c3:	5b                   	pop    %ebx
f01025c4:	5e                   	pop    %esi
f01025c5:	c3                   	ret    

f01025c6 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f01025c6:	53                   	push   %ebx
f01025c7:	83 ec 08             	sub    $0x8,%esp
    /* TODO */
	
	struct PageInfo *ret;
	ret = page_free_list;
f01025ca:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
	//printk("%x\n",page2pa(ret));
	if(!ret)
f01025d0:	85 db                	test   %ebx,%ebx
f01025d2:	74 32                	je     f0102606 <page_alloc+0x40>
		return NULL;

	page_free_list = ret->pp_link;
f01025d4:	8b 03                	mov    (%ebx),%eax
	ret->pp_link = NULL;
f01025d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	num_free_pages--;
f01025dc:	ff 0d cc 76 11 f0    	decl   0xf01176cc

	if(alloc_flags & ALLOC_ZERO)
f01025e2:	f6 44 24 10 01       	testb  $0x1,0x10(%esp)
	ret = page_free_list;
	//printk("%x\n",page2pa(ret));
	if(!ret)
		return NULL;

	page_free_list = ret->pp_link;
f01025e7:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
	ret->pp_link = NULL;
	num_free_pages--;

	if(alloc_flags & ALLOC_ZERO)
f01025ec:	74 18                	je     f0102606 <page_alloc+0x40>
		memset(page2kva(ret),'\0',PGSIZE);
f01025ee:	89 d8                	mov    %ebx,%eax
f01025f0:	e8 64 fc ff ff       	call   f0102259 <page2kva>
f01025f5:	52                   	push   %edx
f01025f6:	68 00 10 00 00       	push   $0x1000
f01025fb:	6a 00                	push   $0x0
f01025fd:	50                   	push   %eax
f01025fe:	e8 cc db ff ff       	call   f01001cf <memset>
f0102603:	83 c4 10             	add    $0x10,%esp
	return ret;	
	
}
f0102606:	89 d8                	mov    %ebx,%eax
f0102608:	83 c4 08             	add    $0x8,%esp
f010260b:	5b                   	pop    %ebx
f010260c:	c3                   	ret    

f010260d <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f010260d:	83 ec 0c             	sub    $0xc,%esp
f0102610:	8b 44 24 10          	mov    0x10(%esp),%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
    /* TODO */
	if(pp->pp_ref)
f0102614:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102619:	74 12                	je     f010262d <page_free+0x20>
		panic("Can't free page %x. Reference Number isn't 0.\n", page2kva(pp));
f010261b:	e8 39 fc ff ff       	call   f0102259 <page2kva>
f0102620:	50                   	push   %eax
f0102621:	68 77 5c 10 f0       	push   $0xf0105c77
f0102626:	68 5c 01 00 00       	push   $0x15c
f010262b:	eb 15                	jmp    f0102642 <page_free+0x35>
	if(pp->pp_link)
f010262d:	83 38 00             	cmpl   $0x0,(%eax)
f0102630:	74 1a                	je     f010264c <page_free+0x3f>
		panic("Page %x  is already free!!\n", page2kva(pp));
f0102632:	e8 22 fc ff ff       	call   f0102259 <page2kva>
f0102637:	50                   	push   %eax
f0102638:	68 a6 5c 10 f0       	push   $0xf0105ca6
f010263d:	68 5e 01 00 00       	push   $0x15e
f0102642:	68 ce 5a 10 f0       	push   $0xf0105ace
f0102647:	e8 f4 15 00 00       	call   f0103c40 <_panic>
	
	pp->pp_ref = 0;
	pp->pp_link = page_free_list;
f010264c:	8b 15 1c 4e 11 f0    	mov    0xf0114e1c,%edx
	if(pp->pp_ref)
		panic("Can't free page %x. Reference Number isn't 0.\n", page2kva(pp));
	if(pp->pp_link)
		panic("Page %x  is already free!!\n", page2kva(pp));
	
	pp->pp_ref = 0;
f0102652:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	pp->pp_link = page_free_list;
	page_free_list = pp;
f0102658:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
		panic("Can't free page %x. Reference Number isn't 0.\n", page2kva(pp));
	if(pp->pp_link)
		panic("Page %x  is already free!!\n", page2kva(pp));
	
	pp->pp_ref = 0;
	pp->pp_link = page_free_list;
f010265d:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
	num_free_pages++;
f010265f:	ff 05 cc 76 11 f0    	incl   0xf01176cc
	return;
		
}
f0102665:	83 c4 0c             	add    $0xc,%esp
f0102668:	c3                   	ret    

f0102669 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f0102669:	83 ec 0c             	sub    $0xc,%esp
f010266c:	8b 44 24 10          	mov    0x10(%esp),%eax
	if (--pp->pp_ref == 0)
f0102670:	8b 50 04             	mov    0x4(%eax),%edx
f0102673:	4a                   	dec    %edx
f0102674:	66 85 d2             	test   %dx,%dx
f0102677:	66 89 50 04          	mov    %dx,0x4(%eax)
f010267b:	75 08                	jne    f0102685 <page_decref+0x1c>
		page_free(pp);
}
f010267d:	83 c4 0c             	add    $0xc,%esp
//
void
page_decref(struct PageInfo* pp)
{
	if (--pp->pp_ref == 0)
		page_free(pp);
f0102680:	e9 88 ff ff ff       	jmp    f010260d <page_free>
}
f0102685:	83 c4 0c             	add    $0xc,%esp
f0102688:	c3                   	ret    

f0102689 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f0102689:	57                   	push   %edi
f010268a:	56                   	push   %esi
f010268b:	53                   	push   %ebx
f010268c:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	// Fill this function in
    /* TODO */
	pte_t *ret;
	struct PageInfo *npageinfo;
	if(!pgdir[PDX(va)])
f0102690:	89 de                	mov    %ebx,%esi
f0102692:	c1 ee 16             	shr    $0x16,%esi
f0102695:	c1 e6 02             	shl    $0x2,%esi
f0102698:	03 74 24 10          	add    0x10(%esp),%esi
f010269c:	83 3e 00             	cmpl   $0x0,(%esi)
f010269f:	75 28                	jne    f01026c9 <pgdir_walk+0x40>
	{  
		if(create == false)
			return NULL;
f01026a1:	31 ff                	xor    %edi,%edi
    /* TODO */
	pte_t *ret;
	struct PageInfo *npageinfo;
	if(!pgdir[PDX(va)])
	{  
		if(create == false)
f01026a3:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
f01026a8:	74 42                	je     f01026ec <pgdir_walk+0x63>
			return NULL;
		else
		{
			npageinfo = page_alloc(1);
f01026aa:	83 ec 0c             	sub    $0xc,%esp
f01026ad:	6a 01                	push   $0x1
f01026af:	e8 12 ff ff ff       	call   f01025c6 <page_alloc>
			if(!npageinfo)
f01026b4:	83 c4 10             	add    $0x10,%esp
f01026b7:	85 c0                	test   %eax,%eax
f01026b9:	74 31                	je     f01026ec <pgdir_walk+0x63>
				return NULL;
			npageinfo->pp_ref++;
f01026bb:	66 ff 40 04          	incw   0x4(%eax)
			pgdir[PDX(va)] = page2pa(npageinfo) | PTE_P | PTE_U | PTE_W;
f01026bf:	e8 24 fb ff ff       	call   f01021e8 <page2pa>
f01026c4:	83 c8 07             	or     $0x7,%eax
f01026c7:	89 06                	mov    %eax,(%esi)
		}
	}

	ret = KADDR(pgdir[PDX(va)] & 0xFFFFF000);
f01026c9:	8b 0e                	mov    (%esi),%ecx
f01026cb:	ba 9e 01 00 00       	mov    $0x19e,%edx
f01026d0:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
	return ret + PTX(va);
f01026d5:	c1 eb 0a             	shr    $0xa,%ebx
f01026d8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
			npageinfo->pp_ref++;
			pgdir[PDX(va)] = page2pa(npageinfo) | PTE_P | PTE_U | PTE_W;
		}
	}

	ret = KADDR(pgdir[PDX(va)] & 0xFFFFF000);
f01026de:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01026e4:	e8 47 fb ff ff       	call   f0102230 <_kaddr>
	return ret + PTX(va);
f01026e9:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
	
}
f01026ec:	89 f8                	mov    %edi,%eax
f01026ee:	5b                   	pop    %ebx
f01026ef:	5e                   	pop    %esi
f01026f0:	5f                   	pop    %edi
f01026f1:	c3                   	ret    

f01026f2 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f01026f2:	55                   	push   %ebp
f01026f3:	89 cd                	mov    %ecx,%ebp
f01026f5:	57                   	push   %edi
    /* TODO */
	pte_t *PTentry;
	int i;
	for(i = 0; i < size/PGSIZE; i++)
f01026f6:	31 ff                	xor    %edi,%edi
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f01026f8:	56                   	push   %esi
f01026f9:	89 d6                	mov    %edx,%esi
f01026fb:	53                   	push   %ebx
f01026fc:	89 c3                	mov    %eax,%ebx
f01026fe:	83 ec 0c             	sub    $0xc,%esp
    /* TODO */
	pte_t *PTentry;
	int i;
	for(i = 0; i < size/PGSIZE; i++)
f0102701:	c1 ed 0c             	shr    $0xc,%ebp
		PTentry = pgdir_walk(pgdir, va+i*PGSIZE, 1);

		if(!PTentry)
			panic("Can't find page table! entry%x",va + i*PGSIZE);

		*PTentry = (pa + i*PGSIZE) | perm | PTE_P;
f0102704:	83 4c 24 24 01       	orl    $0x1,0x24(%esp)
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
    /* TODO */
	pte_t *PTentry;
	int i;
	for(i = 0; i < size/PGSIZE; i++)
f0102709:	eb 41                	jmp    f010274c <boot_map_region+0x5a>
	{
		PTentry = pgdir_walk(pgdir, va+i*PGSIZE, 1);
f010270b:	51                   	push   %ecx
f010270c:	6a 01                	push   $0x1
f010270e:	56                   	push   %esi
f010270f:	53                   	push   %ebx
f0102710:	e8 74 ff ff ff       	call   f0102689 <pgdir_walk>

		if(!PTentry)
f0102715:	83 c4 10             	add    $0x10,%esp
    /* TODO */
	pte_t *PTentry;
	int i;
	for(i = 0; i < size/PGSIZE; i++)
	{
		PTentry = pgdir_walk(pgdir, va+i*PGSIZE, 1);
f0102718:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx

		if(!PTentry)
f010271e:	85 c0                	test   %eax,%eax
f0102720:	75 15                	jne    f0102737 <boot_map_region+0x45>
			panic("Can't find page table! entry%x",va + i*PGSIZE);
f0102722:	56                   	push   %esi
f0102723:	68 c2 5c 10 f0       	push   $0xf0105cc2
f0102728:	68 b9 01 00 00       	push   $0x1b9
f010272d:	68 ce 5a 10 f0       	push   $0xf0105ace
f0102732:	e8 09 15 00 00       	call   f0103c40 <_panic>

		*PTentry = (pa + i*PGSIZE) | perm | PTE_P;
f0102737:	8b 4c 24 24          	mov    0x24(%esp),%ecx
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
    /* TODO */
	pte_t *PTentry;
	int i;
	for(i = 0; i < size/PGSIZE; i++)
f010273b:	47                   	inc    %edi
f010273c:	89 d6                	mov    %edx,%esi
		PTentry = pgdir_walk(pgdir, va+i*PGSIZE, 1);

		if(!PTentry)
			panic("Can't find page table! entry%x",va + i*PGSIZE);

		*PTentry = (pa + i*PGSIZE) | perm | PTE_P;
f010273e:	0b 4c 24 20          	or     0x20(%esp),%ecx
f0102742:	89 08                	mov    %ecx,(%eax)
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
    /* TODO */
	pte_t *PTentry;
	int i;
	for(i = 0; i < size/PGSIZE; i++)
f0102744:	81 44 24 20 00 10 00 	addl   $0x1000,0x20(%esp)
f010274b:	00 
f010274c:	39 ef                	cmp    %ebp,%edi
f010274e:	72 bb                	jb     f010270b <boot_map_region+0x19>
		if(!PTentry)
			panic("Can't find page table! entry%x",va + i*PGSIZE);

		*PTentry = (pa + i*PGSIZE) | perm | PTE_P;
	}
}
f0102750:	83 c4 0c             	add    $0xc,%esp
f0102753:	5b                   	pop    %ebx
f0102754:	5e                   	pop    %esi
f0102755:	5f                   	pop    %edi
f0102756:	5d                   	pop    %ebp
f0102757:	c3                   	ret    

f0102758 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0102758:	53                   	push   %ebx
f0102759:	83 ec 0c             	sub    $0xc,%esp
f010275c:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    /* TODO */
	pte_t *PTentry;
	PTentry = pgdir_walk(pgdir,va,0);
f0102760:	6a 00                	push   $0x0
f0102762:	ff 74 24 1c          	pushl  0x1c(%esp)
f0102766:	ff 74 24 1c          	pushl  0x1c(%esp)
f010276a:	e8 1a ff ff ff       	call   f0102689 <pgdir_walk>
	if(!PTentry)
f010276f:	83 c4 10             	add    $0x10,%esp
f0102772:	85 c0                	test   %eax,%eax
f0102774:	74 16                	je     f010278c <page_lookup+0x34>
		return NULL;
	if(pte_store)
f0102776:	85 db                	test   %ebx,%ebx
f0102778:	74 02                	je     f010277c <page_lookup+0x24>
		*pte_store = PTentry;
f010277a:	89 03                	mov    %eax,(%ebx)

	return pa2page(*PTentry & 0xFFFFF000);
f010277c:	8b 00                	mov    (%eax),%eax
		
}
f010277e:	83 c4 08             	add    $0x8,%esp
f0102781:	5b                   	pop    %ebx
	if(!PTentry)
		return NULL;
	if(pte_store)
		*pte_store = PTentry;

	return pa2page(*PTentry & 0xFFFFF000);
f0102782:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102787:	e9 31 fb ff ff       	jmp    f01022bd <pa2page>
		
}
f010278c:	31 c0                	xor    %eax,%eax
f010278e:	83 c4 08             	add    $0x8,%esp
f0102791:	5b                   	pop    %ebx
f0102792:	c3                   	ret    

f0102793 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0102793:	53                   	push   %ebx
f0102794:	83 ec 1c             	sub    $0x1c,%esp
f0102797:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    /* TODO */
	struct PageInfo *pp;
	pte_t *PTentry = NULL;
	pp = page_lookup(pgdir,va,&PTentry);
f010279b:	8d 44 24 10          	lea    0x10(%esp),%eax
void
page_remove(pde_t *pgdir, void *va)
{
    /* TODO */
	struct PageInfo *pp;
	pte_t *PTentry = NULL;
f010279f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
f01027a6:	00 
	pp = page_lookup(pgdir,va,&PTentry);
f01027a7:	50                   	push   %eax
f01027a8:	53                   	push   %ebx
f01027a9:	ff 74 24 2c          	pushl  0x2c(%esp)
f01027ad:	e8 a6 ff ff ff       	call   f0102758 <page_lookup>
	if(!pp)
f01027b2:	83 c4 10             	add    $0x10,%esp
f01027b5:	85 c0                	test   %eax,%eax
f01027b7:	74 1d                	je     f01027d6 <page_remove+0x43>
		return;
	page_decref(pp);
f01027b9:	83 ec 0c             	sub    $0xc,%esp
f01027bc:	50                   	push   %eax
f01027bd:	e8 a7 fe ff ff       	call   f0102669 <page_decref>
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01027c2:	0f 01 3b             	invlpg (%ebx)

	tlb_invalidate(pgdir,va);
	if(PTentry)
f01027c5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f01027c9:	83 c4 10             	add    $0x10,%esp
f01027cc:	85 c0                	test   %eax,%eax
f01027ce:	74 06                	je     f01027d6 <page_remove+0x43>
		*PTentry = 0;
f01027d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return;
}
f01027d6:	83 c4 18             	add    $0x18,%esp
f01027d9:	5b                   	pop    %ebx
f01027da:	c3                   	ret    

f01027db <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f01027db:	55                   	push   %ebp
f01027dc:	57                   	push   %edi
f01027dd:	56                   	push   %esi
f01027de:	53                   	push   %ebx
f01027df:	83 ec 10             	sub    $0x10,%esp
f01027e2:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
f01027e6:	8b 7c 24 24          	mov    0x24(%esp),%edi
f01027ea:	8b 74 24 28          	mov    0x28(%esp),%esi
    /* TODO */
	pte_t *PTentry;
	PTentry = pgdir_walk(pgdir, va, 1);
f01027ee:	6a 01                	push   $0x1
f01027f0:	55                   	push   %ebp
f01027f1:	57                   	push   %edi
f01027f2:	e8 92 fe ff ff       	call   f0102689 <pgdir_walk>
	if(!PTentry)
f01027f7:	83 c4 10             	add    $0x10,%esp
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
    /* TODO */
	pte_t *PTentry;
	PTentry = pgdir_walk(pgdir, va, 1);
f01027fa:	89 c3                	mov    %eax,%ebx
	if(!PTentry)
		return -E_NO_MEM;
f01027fc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
    /* TODO */
	pte_t *PTentry;
	PTentry = pgdir_walk(pgdir, va, 1);
	if(!PTentry)
f0102801:	85 db                	test   %ebx,%ebx
f0102803:	74 29                	je     f010282e <page_insert+0x53>
		return -E_NO_MEM;
	pp->pp_ref+=1;
f0102805:	66 ff 46 04          	incw   0x4(%esi)
	if(*PTentry)
f0102809:	83 3b 00             	cmpl   $0x0,(%ebx)
f010280c:	74 0c                	je     f010281a <page_insert+0x3f>
		page_remove(pgdir, va);
f010280e:	50                   	push   %eax
f010280f:	50                   	push   %eax
f0102810:	55                   	push   %ebp
f0102811:	57                   	push   %edi
f0102812:	e8 7c ff ff ff       	call   f0102793 <page_remove>
f0102817:	83 c4 10             	add    $0x10,%esp
	*PTentry = page2pa(pp) | perm | PTE_P;
f010281a:	89 f0                	mov    %esi,%eax
f010281c:	e8 c7 f9 ff ff       	call   f01021e8 <page2pa>
f0102821:	8b 54 24 2c          	mov    0x2c(%esp),%edx
f0102825:	83 ca 01             	or     $0x1,%edx
f0102828:	09 c2                	or     %eax,%edx

	return 0;
f010282a:	31 c0                	xor    %eax,%eax
	if(!PTentry)
		return -E_NO_MEM;
	pp->pp_ref+=1;
	if(*PTentry)
		page_remove(pgdir, va);
	*PTentry = page2pa(pp) | perm | PTE_P;
f010282c:	89 13                	mov    %edx,(%ebx)

	return 0;
}
f010282e:	83 c4 0c             	add    $0xc,%esp
f0102831:	5b                   	pop    %ebx
f0102832:	5e                   	pop    %esi
f0102833:	5f                   	pop    %edi
f0102834:	5d                   	pop    %ebp
f0102835:	c3                   	ret    

f0102836 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102836:	55                   	push   %ebp
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0102837:	b8 15 00 00 00       	mov    $0x15,%eax
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f010283c:	57                   	push   %edi
f010283d:	56                   	push   %esi
f010283e:	53                   	push   %ebx
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f010283f:	bb 04 00 00 00       	mov    $0x4,%ebx
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102844:	83 ec 2c             	sub    $0x2c,%esp
	uint32_t cr0;
	nextfree = 0;
f0102847:	c7 05 20 4e 11 f0 00 	movl   $0x0,0xf0114e20
f010284e:	00 00 00 
	page_free_list = 0;
f0102851:	c7 05 1c 4e 11 f0 00 	movl   $0x0,0xf0114e1c
f0102858:	00 00 00 
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f010285b:	e8 a0 fc ff ff       	call   f0102500 <nvram_read>
f0102860:	99                   	cltd   
f0102861:	f7 fb                	idiv   %ebx
f0102863:	a3 24 4e 11 f0       	mov    %eax,0xf0114e24
  npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f0102868:	b8 17 00 00 00       	mov    $0x17,%eax
f010286d:	e8 8e fc ff ff       	call   f0102500 <nvram_read>
f0102872:	99                   	cltd   
f0102873:	f7 fb                	idiv   %ebx

  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
f0102875:	85 c0                	test   %eax,%eax
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f0102877:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
  npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;

  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
f010287d:	75 06                	jne    f0102885 <mem_init+0x4f>
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;
f010287f:	8b 15 24 4e 11 f0    	mov    0xf0114e24,%edx

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
      npages_extmem * PGSIZE / 1024);
f0102885:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0102888:	c1 e8 0a             	shr    $0xa,%eax
f010288b:	50                   	push   %eax
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
f010288c:	a1 24 4e 11 f0       	mov    0xf0114e24,%eax
  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;
f0102891:	89 15 c4 76 11 f0    	mov    %edx,0xf01176c4

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
f0102897:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010289a:	c1 e8 0a             	shr    $0xa,%eax
f010289d:	50                   	push   %eax
      npages * PGSIZE / 1024,
f010289e:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f01028a3:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01028a6:	c1 e8 0a             	shr    $0xa,%eax
f01028a9:	50                   	push   %eax
f01028aa:	68 e1 5c 10 f0       	push   $0xf0105ce1
f01028af:	e8 1c f9 ff ff       	call   f01021d0 <printk>

	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();
	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01028b4:	b8 00 10 00 00       	mov    $0x1000,%eax
f01028b9:	e8 37 f9 ff ff       	call   f01021f5 <boot_alloc>
	memset(kern_pgdir, 0, PGSIZE);
f01028be:	83 c4 0c             	add    $0xc,%esp
f01028c1:	68 00 10 00 00       	push   $0x1000
f01028c6:	6a 00                	push   $0x0
f01028c8:	50                   	push   %eax

	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();
	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01028c9:	a3 c8 76 11 f0       	mov    %eax,0xf01176c8
	memset(kern_pgdir, 0, PGSIZE);
f01028ce:	e8 fc d8 ff ff       	call   f01001cf <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01028d3:	8b 1d c8 76 11 f0    	mov    0xf01176c8,%ebx
f01028d9:	b8 8d 00 00 00       	mov    $0x8d,%eax
f01028de:	89 da                	mov    %ebx,%edx
f01028e0:	e8 3e fc ff ff       	call   f0102523 <_paddr.clone.0>
f01028e5:	83 c8 05             	or     $0x5,%eax
f01028e8:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
    /* TODO */
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f01028ee:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
	
	
	for(i = 0; i < npages ; i++)
f01028f3:	31 db                	xor    %ebx,%ebx
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
    /* TODO */
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f01028f5:	c1 e0 03             	shl    $0x3,%eax
f01028f8:	e8 f8 f8 ff ff       	call   f01021f5 <boot_alloc>
	
	
	for(i = 0; i < npages ; i++)
f01028fd:	83 c4 10             	add    $0x10,%esp
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
    /* TODO */
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
f0102900:	a3 d0 76 11 f0       	mov    %eax,0xf01176d0
	
	
	for(i = 0; i < npages ; i++)
f0102905:	eb 1c                	jmp    f0102923 <mem_init+0xed>
		memset(&(pages[i]),0x00,sizeof(struct PageInfo));
f0102907:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
	// Your code goes here:
    /* TODO */
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
	
	
	for(i = 0; i < npages ; i++)
f010290e:	43                   	inc    %ebx
		memset(&(pages[i]),0x00,sizeof(struct PageInfo));
f010290f:	56                   	push   %esi
f0102910:	03 05 d0 76 11 f0    	add    0xf01176d0,%eax
f0102916:	6a 08                	push   $0x8
f0102918:	6a 00                	push   $0x0
f010291a:	50                   	push   %eax
f010291b:	e8 af d8 ff ff       	call   f01001cf <memset>
	// Your code goes here:
    /* TODO */
	pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo) * npages);
	
	
	for(i = 0; i < npages ; i++)
f0102920:	83 c4 10             	add    $0x10,%esp
f0102923:	3b 1d c4 76 11 f0    	cmp    0xf01176c4,%ebx
f0102929:	72 dc                	jb     f0102907 <mem_init+0xd1>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f010292b:	e8 19 fc ff ff       	call   f0102549 <page_init>

	check_page_free_list(1);
f0102930:	b8 01 00 00 00       	mov    $0x1,%eax
f0102935:	e8 b0 f9 ff ff       	call   f01022ea <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f010293a:	83 3d d0 76 11 f0 00 	cmpl   $0x0,0xf01176d0
f0102941:	75 0d                	jne    f0102950 <mem_init+0x11a>
		panic("'pages' is a null pointer!");
f0102943:	51                   	push   %ecx
f0102944:	68 1d 5d 10 f0       	push   $0xf0105d1d
f0102949:	68 d0 02 00 00       	push   $0x2d0
f010294e:	eb 34                	jmp    f0102984 <mem_init+0x14e>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0102950:	a1 1c 4e 11 f0       	mov    0xf0114e1c,%eax
f0102955:	31 f6                	xor    %esi,%esi
f0102957:	eb 03                	jmp    f010295c <mem_init+0x126>
f0102959:	8b 00                	mov    (%eax),%eax
		++nfree;
f010295b:	46                   	inc    %esi

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010295c:	85 c0                	test   %eax,%eax
f010295e:	75 f9                	jne    f0102959 <mem_init+0x123>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102960:	83 ec 0c             	sub    $0xc,%esp
f0102963:	6a 00                	push   $0x0
f0102965:	e8 5c fc ff ff       	call   f01025c6 <page_alloc>
f010296a:	89 44 24 18          	mov    %eax,0x18(%esp)
f010296e:	83 c4 10             	add    $0x10,%esp
f0102971:	85 c0                	test   %eax,%eax
f0102973:	75 19                	jne    f010298e <mem_init+0x158>
f0102975:	68 38 5d 10 f0       	push   $0xf0105d38
f010297a:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010297f:	68 d8 02 00 00       	push   $0x2d8
f0102984:	68 ce 5a 10 f0       	push   $0xf0105ace
f0102989:	e8 b2 12 00 00       	call   f0103c40 <_panic>
	assert((pp1 = page_alloc(0)));
f010298e:	83 ec 0c             	sub    $0xc,%esp
f0102991:	6a 00                	push   $0x0
f0102993:	e8 2e fc ff ff       	call   f01025c6 <page_alloc>
f0102998:	83 c4 10             	add    $0x10,%esp
f010299b:	85 c0                	test   %eax,%eax
f010299d:	89 c7                	mov    %eax,%edi
f010299f:	75 11                	jne    f01029b2 <mem_init+0x17c>
f01029a1:	68 4e 5d 10 f0       	push   $0xf0105d4e
f01029a6:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01029ab:	68 d9 02 00 00       	push   $0x2d9
f01029b0:	eb d2                	jmp    f0102984 <mem_init+0x14e>
	assert((pp2 = page_alloc(0)));
f01029b2:	83 ec 0c             	sub    $0xc,%esp
f01029b5:	6a 00                	push   $0x0
f01029b7:	e8 0a fc ff ff       	call   f01025c6 <page_alloc>
f01029bc:	83 c4 10             	add    $0x10,%esp
f01029bf:	85 c0                	test   %eax,%eax
f01029c1:	89 c3                	mov    %eax,%ebx
f01029c3:	75 11                	jne    f01029d6 <mem_init+0x1a0>
f01029c5:	68 64 5d 10 f0       	push   $0xf0105d64
f01029ca:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01029cf:	68 da 02 00 00       	push   $0x2da
f01029d4:	eb ae                	jmp    f0102984 <mem_init+0x14e>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01029d6:	3b 7c 24 08          	cmp    0x8(%esp),%edi
f01029da:	75 11                	jne    f01029ed <mem_init+0x1b7>
f01029dc:	68 7a 5d 10 f0       	push   $0xf0105d7a
f01029e1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01029e6:	68 dd 02 00 00       	push   $0x2dd
f01029eb:	eb 97                	jmp    f0102984 <mem_init+0x14e>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01029ed:	39 f8                	cmp    %edi,%eax
f01029ef:	74 06                	je     f01029f7 <mem_init+0x1c1>
f01029f1:	3b 44 24 08          	cmp    0x8(%esp),%eax
f01029f5:	75 14                	jne    f0102a0b <mem_init+0x1d5>
f01029f7:	68 8c 5d 10 f0       	push   $0xf0105d8c
f01029fc:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a01:	68 de 02 00 00       	push   $0x2de
f0102a06:	e9 79 ff ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(page2pa(pp0) < npages*PGSIZE);
f0102a0b:	8b 44 24 08          	mov    0x8(%esp),%eax
f0102a0f:	e8 d4 f7 ff ff       	call   f01021e8 <page2pa>
f0102a14:	8b 2d c4 76 11 f0    	mov    0xf01176c4,%ebp
f0102a1a:	c1 e5 0c             	shl    $0xc,%ebp
f0102a1d:	39 e8                	cmp    %ebp,%eax
f0102a1f:	72 14                	jb     f0102a35 <mem_init+0x1ff>
f0102a21:	68 ac 5d 10 f0       	push   $0xf0105dac
f0102a26:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a2b:	68 df 02 00 00       	push   $0x2df
f0102a30:	e9 4f ff ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(page2pa(pp1) < npages*PGSIZE);
f0102a35:	89 f8                	mov    %edi,%eax
f0102a37:	e8 ac f7 ff ff       	call   f01021e8 <page2pa>
f0102a3c:	39 e8                	cmp    %ebp,%eax
f0102a3e:	72 14                	jb     f0102a54 <mem_init+0x21e>
f0102a40:	68 c9 5d 10 f0       	push   $0xf0105dc9
f0102a45:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a4a:	68 e0 02 00 00       	push   $0x2e0
f0102a4f:	e9 30 ff ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(page2pa(pp2) < npages*PGSIZE);
f0102a54:	89 d8                	mov    %ebx,%eax
f0102a56:	e8 8d f7 ff ff       	call   f01021e8 <page2pa>
f0102a5b:	39 e8                	cmp    %ebp,%eax
f0102a5d:	72 14                	jb     f0102a73 <mem_init+0x23d>
f0102a5f:	68 e6 5d 10 f0       	push   $0xf0105de6
f0102a64:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a69:	68 e1 02 00 00       	push   $0x2e1
f0102a6e:	e9 11 ff ff ff       	jmp    f0102984 <mem_init+0x14e>
	// temporarily steal the rest of the free pages
	fl = page_free_list;
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102a73:	83 ec 0c             	sub    $0xc,%esp
	assert(page2pa(pp0) < npages*PGSIZE);
	assert(page2pa(pp1) < npages*PGSIZE);
	assert(page2pa(pp2) < npages*PGSIZE);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102a76:	8b 2d 1c 4e 11 f0    	mov    0xf0114e1c,%ebp
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102a7c:	6a 00                	push   $0x0
	assert(page2pa(pp1) < npages*PGSIZE);
	assert(page2pa(pp2) < npages*PGSIZE);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
	page_free_list = 0;
f0102a7e:	c7 05 1c 4e 11 f0 00 	movl   $0x0,0xf0114e1c
f0102a85:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0102a88:	e8 39 fb ff ff       	call   f01025c6 <page_alloc>
f0102a8d:	83 c4 10             	add    $0x10,%esp
f0102a90:	85 c0                	test   %eax,%eax
f0102a92:	74 14                	je     f0102aa8 <mem_init+0x272>
f0102a94:	68 03 5e 10 f0       	push   $0xf0105e03
f0102a99:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a9e:	68 e8 02 00 00       	push   $0x2e8
f0102aa3:	e9 dc fe ff ff       	jmp    f0102984 <mem_init+0x14e>

	// free and re-allocate?
	page_free(pp0);
f0102aa8:	83 ec 0c             	sub    $0xc,%esp
f0102aab:	ff 74 24 14          	pushl  0x14(%esp)
f0102aaf:	e8 59 fb ff ff       	call   f010260d <page_free>
	page_free(pp1);
f0102ab4:	89 3c 24             	mov    %edi,(%esp)
f0102ab7:	e8 51 fb ff ff       	call   f010260d <page_free>
	page_free(pp2);
f0102abc:	89 1c 24             	mov    %ebx,(%esp)
f0102abf:	e8 49 fb ff ff       	call   f010260d <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102ac4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102acb:	e8 f6 fa ff ff       	call   f01025c6 <page_alloc>
f0102ad0:	83 c4 10             	add    $0x10,%esp
f0102ad3:	85 c0                	test   %eax,%eax
f0102ad5:	89 c3                	mov    %eax,%ebx
f0102ad7:	75 14                	jne    f0102aed <mem_init+0x2b7>
f0102ad9:	68 38 5d 10 f0       	push   $0xf0105d38
f0102ade:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ae3:	68 ef 02 00 00       	push   $0x2ef
f0102ae8:	e9 97 fe ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert((pp1 = page_alloc(0)));
f0102aed:	83 ec 0c             	sub    $0xc,%esp
f0102af0:	6a 00                	push   $0x0
f0102af2:	e8 cf fa ff ff       	call   f01025c6 <page_alloc>
f0102af7:	89 44 24 18          	mov    %eax,0x18(%esp)
f0102afb:	83 c4 10             	add    $0x10,%esp
f0102afe:	85 c0                	test   %eax,%eax
f0102b00:	75 14                	jne    f0102b16 <mem_init+0x2e0>
f0102b02:	68 4e 5d 10 f0       	push   $0xf0105d4e
f0102b07:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b0c:	68 f0 02 00 00       	push   $0x2f0
f0102b11:	e9 6e fe ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert((pp2 = page_alloc(0)));
f0102b16:	83 ec 0c             	sub    $0xc,%esp
f0102b19:	6a 00                	push   $0x0
f0102b1b:	e8 a6 fa ff ff       	call   f01025c6 <page_alloc>
f0102b20:	83 c4 10             	add    $0x10,%esp
f0102b23:	85 c0                	test   %eax,%eax
f0102b25:	89 c7                	mov    %eax,%edi
f0102b27:	75 14                	jne    f0102b3d <mem_init+0x307>
f0102b29:	68 64 5d 10 f0       	push   $0xf0105d64
f0102b2e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b33:	68 f1 02 00 00       	push   $0x2f1
f0102b38:	e9 47 fe ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102b3d:	39 5c 24 08          	cmp    %ebx,0x8(%esp)
f0102b41:	75 14                	jne    f0102b57 <mem_init+0x321>
f0102b43:	68 7a 5d 10 f0       	push   $0xf0105d7a
f0102b48:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b4d:	68 f3 02 00 00       	push   $0x2f3
f0102b52:	e9 2d fe ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102b57:	3b 44 24 08          	cmp    0x8(%esp),%eax
f0102b5b:	74 04                	je     f0102b61 <mem_init+0x32b>
f0102b5d:	39 d8                	cmp    %ebx,%eax
f0102b5f:	75 14                	jne    f0102b75 <mem_init+0x33f>
f0102b61:	68 8c 5d 10 f0       	push   $0xf0105d8c
f0102b66:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b6b:	68 f4 02 00 00       	push   $0x2f4
f0102b70:	e9 0f fe ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(!page_alloc(0));
f0102b75:	83 ec 0c             	sub    $0xc,%esp
f0102b78:	6a 00                	push   $0x0
f0102b7a:	e8 47 fa ff ff       	call   f01025c6 <page_alloc>
f0102b7f:	83 c4 10             	add    $0x10,%esp
f0102b82:	85 c0                	test   %eax,%eax
f0102b84:	74 14                	je     f0102b9a <mem_init+0x364>
f0102b86:	68 03 5e 10 f0       	push   $0xf0105e03
f0102b8b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b90:	68 f5 02 00 00       	push   $0x2f5
f0102b95:	e9 ea fd ff ff       	jmp    f0102984 <mem_init+0x14e>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0102b9a:	89 d8                	mov    %ebx,%eax
f0102b9c:	e8 b8 f6 ff ff       	call   f0102259 <page2kva>
f0102ba1:	52                   	push   %edx
f0102ba2:	68 00 10 00 00       	push   $0x1000
f0102ba7:	6a 01                	push   $0x1
f0102ba9:	50                   	push   %eax
f0102baa:	e8 20 d6 ff ff       	call   f01001cf <memset>
	page_free(pp0);
f0102baf:	89 1c 24             	mov    %ebx,(%esp)
f0102bb2:	e8 56 fa ff ff       	call   f010260d <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0102bb7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0102bbe:	e8 03 fa ff ff       	call   f01025c6 <page_alloc>
f0102bc3:	83 c4 10             	add    $0x10,%esp
f0102bc6:	85 c0                	test   %eax,%eax
f0102bc8:	75 14                	jne    f0102bde <mem_init+0x3a8>
f0102bca:	68 12 5e 10 f0       	push   $0xf0105e12
f0102bcf:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102bd4:	68 fa 02 00 00       	push   $0x2fa
f0102bd9:	e9 a6 fd ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp && pp0 == pp);
f0102bde:	39 c3                	cmp    %eax,%ebx
f0102be0:	74 14                	je     f0102bf6 <mem_init+0x3c0>
f0102be2:	68 30 5e 10 f0       	push   $0xf0105e30
f0102be7:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102bec:	68 fb 02 00 00       	push   $0x2fb
f0102bf1:	e9 8e fd ff ff       	jmp    f0102984 <mem_init+0x14e>
	c = page2kva(pp);
f0102bf6:	89 d8                	mov    %ebx,%eax
f0102bf8:	e8 5c f6 ff ff       	call   f0102259 <page2kva>
	for (i = 0; i < PGSIZE; i++)
f0102bfd:	31 d2                	xor    %edx,%edx
		assert(c[i] == 0);
f0102bff:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
f0102c03:	74 14                	je     f0102c19 <mem_init+0x3e3>
f0102c05:	68 40 5e 10 f0       	push   $0xf0105e40
f0102c0a:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102c0f:	68 fe 02 00 00       	push   $0x2fe
f0102c14:	e9 6b fd ff ff       	jmp    f0102984 <mem_init+0x14e>
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0102c19:	42                   	inc    %edx
f0102c1a:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
f0102c20:	75 dd                	jne    f0102bff <mem_init+0x3c9>

	// give free list back
	page_free_list = fl;

	// free the pages we took
	page_free(pp0);
f0102c22:	83 ec 0c             	sub    $0xc,%esp
f0102c25:	53                   	push   %ebx
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0102c26:	89 2d 1c 4e 11 f0    	mov    %ebp,0xf0114e1c

	// free the pages we took
	page_free(pp0);
f0102c2c:	e8 dc f9 ff ff       	call   f010260d <page_free>
	page_free(pp1);
f0102c31:	5b                   	pop    %ebx
f0102c32:	ff 74 24 14          	pushl  0x14(%esp)
f0102c36:	e8 d2 f9 ff ff       	call   f010260d <page_free>
	page_free(pp2);
f0102c3b:	89 3c 24             	mov    %edi,(%esp)
f0102c3e:	e8 ca f9 ff ff       	call   f010260d <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102c43:	a1 1c 4e 11 f0       	mov    0xf0114e1c,%eax
f0102c48:	83 c4 10             	add    $0x10,%esp
f0102c4b:	eb 03                	jmp    f0102c50 <mem_init+0x41a>
f0102c4d:	8b 00                	mov    (%eax),%eax
		--nfree;
f0102c4f:	4e                   	dec    %esi
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102c50:	85 c0                	test   %eax,%eax
f0102c52:	75 f9                	jne    f0102c4d <mem_init+0x417>
		--nfree;
	assert(nfree == 0);
f0102c54:	85 f6                	test   %esi,%esi
f0102c56:	74 14                	je     f0102c6c <mem_init+0x436>
f0102c58:	68 4a 5e 10 f0       	push   $0xf0105e4a
f0102c5d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102c62:	68 0b 03 00 00       	push   $0x30b
f0102c67:	e9 18 fd ff ff       	jmp    f0102984 <mem_init+0x14e>

	printk("check_page_alloc() succeeded!\n");
f0102c6c:	83 ec 0c             	sub    $0xc,%esp
f0102c6f:	68 55 5e 10 f0       	push   $0xf0105e55
f0102c74:	e8 57 f5 ff ff       	call   f01021d0 <printk>
	void *va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102c79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102c80:	e8 41 f9 ff ff       	call   f01025c6 <page_alloc>
f0102c85:	83 c4 10             	add    $0x10,%esp
f0102c88:	85 c0                	test   %eax,%eax
f0102c8a:	89 c6                	mov    %eax,%esi
f0102c8c:	75 14                	jne    f0102ca2 <mem_init+0x46c>
f0102c8e:	68 38 5d 10 f0       	push   $0xf0105d38
f0102c93:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102c98:	68 67 03 00 00       	push   $0x367
f0102c9d:	e9 e2 fc ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert((pp1 = page_alloc(0)));
f0102ca2:	83 ec 0c             	sub    $0xc,%esp
f0102ca5:	6a 00                	push   $0x0
f0102ca7:	e8 1a f9 ff ff       	call   f01025c6 <page_alloc>
f0102cac:	83 c4 10             	add    $0x10,%esp
f0102caf:	85 c0                	test   %eax,%eax
f0102cb1:	89 c3                	mov    %eax,%ebx
f0102cb3:	75 14                	jne    f0102cc9 <mem_init+0x493>
f0102cb5:	68 4e 5d 10 f0       	push   $0xf0105d4e
f0102cba:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102cbf:	68 68 03 00 00       	push   $0x368
f0102cc4:	e9 bb fc ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert((pp2 = page_alloc(0)));
f0102cc9:	83 ec 0c             	sub    $0xc,%esp
f0102ccc:	6a 00                	push   $0x0
f0102cce:	e8 f3 f8 ff ff       	call   f01025c6 <page_alloc>
f0102cd3:	83 c4 10             	add    $0x10,%esp
f0102cd6:	85 c0                	test   %eax,%eax
f0102cd8:	89 c7                	mov    %eax,%edi
f0102cda:	75 14                	jne    f0102cf0 <mem_init+0x4ba>
f0102cdc:	68 64 5d 10 f0       	push   $0xf0105d64
f0102ce1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ce6:	68 69 03 00 00       	push   $0x369
f0102ceb:	e9 94 fc ff ff       	jmp    f0102984 <mem_init+0x14e>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102cf0:	39 f3                	cmp    %esi,%ebx
f0102cf2:	75 14                	jne    f0102d08 <mem_init+0x4d2>
f0102cf4:	68 7a 5d 10 f0       	push   $0xf0105d7a
f0102cf9:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102cfe:	68 6c 03 00 00       	push   $0x36c
f0102d03:	e9 7c fc ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102d08:	39 d8                	cmp    %ebx,%eax
f0102d0a:	74 04                	je     f0102d10 <mem_init+0x4da>
f0102d0c:	39 f0                	cmp    %esi,%eax
f0102d0e:	75 14                	jne    f0102d24 <mem_init+0x4ee>
f0102d10:	68 8c 5d 10 f0       	push   $0xf0105d8c
f0102d15:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102d1a:	68 6d 03 00 00       	push   $0x36d
f0102d1f:	e9 60 fc ff ff       	jmp    f0102984 <mem_init+0x14e>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102d24:	a1 1c 4e 11 f0       	mov    0xf0114e1c,%eax
	page_free_list = 0;
f0102d29:	c7 05 1c 4e 11 f0 00 	movl   $0x0,0xf0114e1c
f0102d30:	00 00 00 
	assert(pp0);
	assert(pp1 && pp1 != pp0);
	assert(pp2 && pp2 != pp1 && pp2 != pp0);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102d33:	89 44 24 08          	mov    %eax,0x8(%esp)
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102d37:	83 ec 0c             	sub    $0xc,%esp
f0102d3a:	6a 00                	push   $0x0
f0102d3c:	e8 85 f8 ff ff       	call   f01025c6 <page_alloc>
f0102d41:	83 c4 10             	add    $0x10,%esp
f0102d44:	85 c0                	test   %eax,%eax
f0102d46:	74 14                	je     f0102d5c <mem_init+0x526>
f0102d48:	68 03 5e 10 f0       	push   $0xf0105e03
f0102d4d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102d52:	68 74 03 00 00       	push   $0x374
f0102d57:	e9 28 fc ff ff       	jmp    f0102984 <mem_init+0x14e>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102d5c:	51                   	push   %ecx
f0102d5d:	8d 44 24 20          	lea    0x20(%esp),%eax
f0102d61:	50                   	push   %eax
f0102d62:	6a 00                	push   $0x0
f0102d64:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102d6a:	e8 e9 f9 ff ff       	call   f0102758 <page_lookup>
f0102d6f:	83 c4 10             	add    $0x10,%esp
f0102d72:	85 c0                	test   %eax,%eax
f0102d74:	74 14                	je     f0102d8a <mem_init+0x554>
f0102d76:	68 74 5e 10 f0       	push   $0xf0105e74
f0102d7b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102d80:	68 77 03 00 00       	push   $0x377
f0102d85:	e9 fa fb ff ff       	jmp    f0102984 <mem_init+0x14e>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102d8a:	6a 02                	push   $0x2
f0102d8c:	6a 00                	push   $0x0
f0102d8e:	53                   	push   %ebx
f0102d8f:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102d95:	e8 41 fa ff ff       	call   f01027db <page_insert>
f0102d9a:	83 c4 10             	add    $0x10,%esp
f0102d9d:	85 c0                	test   %eax,%eax
f0102d9f:	78 14                	js     f0102db5 <mem_init+0x57f>
f0102da1:	68 a9 5e 10 f0       	push   $0xf0105ea9
f0102da6:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102dab:	68 7a 03 00 00       	push   $0x37a
f0102db0:	e9 cf fb ff ff       	jmp    f0102984 <mem_init+0x14e>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0102db5:	83 ec 0c             	sub    $0xc,%esp
f0102db8:	56                   	push   %esi
f0102db9:	e8 4f f8 ff ff       	call   f010260d <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102dbe:	6a 02                	push   $0x2
f0102dc0:	6a 00                	push   $0x0
f0102dc2:	53                   	push   %ebx
f0102dc3:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102dc9:	e8 0d fa ff ff       	call   f01027db <page_insert>
f0102dce:	83 c4 20             	add    $0x20,%esp
f0102dd1:	85 c0                	test   %eax,%eax
f0102dd3:	74 14                	je     f0102de9 <mem_init+0x5b3>
f0102dd5:	68 d6 5e 10 f0       	push   $0xf0105ed6
f0102dda:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ddf:	68 7e 03 00 00       	push   $0x37e
f0102de4:	e9 9b fb ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102de9:	8b 2d c8 76 11 f0    	mov    0xf01176c8,%ebp
f0102def:	89 f0                	mov    %esi,%eax
f0102df1:	e8 f2 f3 ff ff       	call   f01021e8 <page2pa>
f0102df6:	8b 55 00             	mov    0x0(%ebp),%edx
f0102df9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102dff:	39 c2                	cmp    %eax,%edx
f0102e01:	74 14                	je     f0102e17 <mem_init+0x5e1>
f0102e03:	68 04 5f 10 f0       	push   $0xf0105f04
f0102e08:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e0d:	68 7f 03 00 00       	push   $0x37f
f0102e12:	e9 6d fb ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102e17:	31 d2                	xor    %edx,%edx
f0102e19:	89 e8                	mov    %ebp,%eax
f0102e1b:	e8 52 f4 ff ff       	call   f0102272 <check_va2pa>
f0102e20:	89 c5                	mov    %eax,%ebp
f0102e22:	89 d8                	mov    %ebx,%eax
f0102e24:	e8 bf f3 ff ff       	call   f01021e8 <page2pa>
f0102e29:	39 c5                	cmp    %eax,%ebp
f0102e2b:	74 14                	je     f0102e41 <mem_init+0x60b>
f0102e2d:	68 2c 5f 10 f0       	push   $0xf0105f2c
f0102e32:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e37:	68 80 03 00 00       	push   $0x380
f0102e3c:	e9 43 fb ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp1->pp_ref == 1);
f0102e41:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102e46:	74 14                	je     f0102e5c <mem_init+0x626>
f0102e48:	68 59 5f 10 f0       	push   $0xf0105f59
f0102e4d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e52:	68 81 03 00 00       	push   $0x381
f0102e57:	e9 28 fb ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp0->pp_ref == 1);
f0102e5c:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e61:	74 14                	je     f0102e77 <mem_init+0x641>
f0102e63:	68 6a 5f 10 f0       	push   $0xf0105f6a
f0102e68:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e6d:	68 82 03 00 00       	push   $0x382
f0102e72:	e9 0d fb ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102e77:	6a 02                	push   $0x2
f0102e79:	68 00 10 00 00       	push   $0x1000
f0102e7e:	57                   	push   %edi
f0102e7f:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102e85:	e8 51 f9 ff ff       	call   f01027db <page_insert>
f0102e8a:	83 c4 10             	add    $0x10,%esp
f0102e8d:	85 c0                	test   %eax,%eax
f0102e8f:	74 14                	je     f0102ea5 <mem_init+0x66f>
f0102e91:	68 7b 5f 10 f0       	push   $0xf0105f7b
f0102e96:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e9b:	68 85 03 00 00       	push   $0x385
f0102ea0:	e9 df fa ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102ea5:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0102eaa:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102eaf:	e8 be f3 ff ff       	call   f0102272 <check_va2pa>
f0102eb4:	89 c5                	mov    %eax,%ebp
f0102eb6:	89 f8                	mov    %edi,%eax
f0102eb8:	e8 2b f3 ff ff       	call   f01021e8 <page2pa>
f0102ebd:	39 c5                	cmp    %eax,%ebp
f0102ebf:	74 14                	je     f0102ed5 <mem_init+0x69f>
f0102ec1:	68 b4 5f 10 f0       	push   $0xf0105fb4
f0102ec6:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ecb:	68 86 03 00 00       	push   $0x386
f0102ed0:	e9 af fa ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2->pp_ref == 1);
f0102ed5:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102eda:	74 14                	je     f0102ef0 <mem_init+0x6ba>
f0102edc:	68 e4 5f 10 f0       	push   $0xf0105fe4
f0102ee1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ee6:	68 87 03 00 00       	push   $0x387
f0102eeb:	e9 94 fa ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should be no free memory
	assert(!page_alloc(0));
f0102ef0:	83 ec 0c             	sub    $0xc,%esp
f0102ef3:	6a 00                	push   $0x0
f0102ef5:	e8 cc f6 ff ff       	call   f01025c6 <page_alloc>
f0102efa:	83 c4 10             	add    $0x10,%esp
f0102efd:	85 c0                	test   %eax,%eax
f0102eff:	74 14                	je     f0102f15 <mem_init+0x6df>
f0102f01:	68 03 5e 10 f0       	push   $0xf0105e03
f0102f06:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f0b:	68 8a 03 00 00       	push   $0x38a
f0102f10:	e9 6f fa ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102f15:	6a 02                	push   $0x2
f0102f17:	68 00 10 00 00       	push   $0x1000
f0102f1c:	57                   	push   %edi
f0102f1d:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102f23:	e8 b3 f8 ff ff       	call   f01027db <page_insert>
f0102f28:	83 c4 10             	add    $0x10,%esp
f0102f2b:	85 c0                	test   %eax,%eax
f0102f2d:	74 14                	je     f0102f43 <mem_init+0x70d>
f0102f2f:	68 7b 5f 10 f0       	push   $0xf0105f7b
f0102f34:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f39:	68 8d 03 00 00       	push   $0x38d
f0102f3e:	e9 41 fa ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102f43:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0102f48:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102f4d:	e8 20 f3 ff ff       	call   f0102272 <check_va2pa>
f0102f52:	89 c5                	mov    %eax,%ebp
f0102f54:	89 f8                	mov    %edi,%eax
f0102f56:	e8 8d f2 ff ff       	call   f01021e8 <page2pa>
f0102f5b:	39 c5                	cmp    %eax,%ebp
f0102f5d:	74 14                	je     f0102f73 <mem_init+0x73d>
f0102f5f:	68 b4 5f 10 f0       	push   $0xf0105fb4
f0102f64:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f69:	68 8e 03 00 00       	push   $0x38e
f0102f6e:	e9 11 fa ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2->pp_ref == 1);
f0102f73:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102f78:	74 14                	je     f0102f8e <mem_init+0x758>
f0102f7a:	68 e4 5f 10 f0       	push   $0xf0105fe4
f0102f7f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f84:	68 8f 03 00 00       	push   $0x38f
f0102f89:	e9 f6 f9 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0102f8e:	83 ec 0c             	sub    $0xc,%esp
f0102f91:	6a 00                	push   $0x0
f0102f93:	e8 2e f6 ff ff       	call   f01025c6 <page_alloc>
f0102f98:	83 c4 10             	add    $0x10,%esp
f0102f9b:	85 c0                	test   %eax,%eax
f0102f9d:	74 14                	je     f0102fb3 <mem_init+0x77d>
f0102f9f:	68 03 5e 10 f0       	push   $0xf0105e03
f0102fa4:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102fa9:	68 93 03 00 00       	push   $0x393
f0102fae:	e9 d1 f9 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0102fb3:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0102fb8:	ba 96 03 00 00       	mov    $0x396,%edx
f0102fbd:	8b 08                	mov    (%eax),%ecx
f0102fbf:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
f0102fc4:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102fca:	e8 61 f2 ff ff       	call   f0102230 <_kaddr>
f0102fcf:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102fd3:	52                   	push   %edx
f0102fd4:	6a 00                	push   $0x0
f0102fd6:	68 00 10 00 00       	push   $0x1000
f0102fdb:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102fe1:	e8 a3 f6 ff ff       	call   f0102689 <pgdir_walk>
f0102fe6:	8b 54 24 2c          	mov    0x2c(%esp),%edx
f0102fea:	83 c4 10             	add    $0x10,%esp
f0102fed:	83 c2 04             	add    $0x4,%edx
f0102ff0:	39 d0                	cmp    %edx,%eax
f0102ff2:	74 14                	je     f0103008 <mem_init+0x7d2>
f0102ff4:	68 f5 5f 10 f0       	push   $0xf0105ff5
f0102ff9:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ffe:	68 97 03 00 00       	push   $0x397
f0103003:	e9 7c f9 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0103008:	6a 06                	push   $0x6
f010300a:	68 00 10 00 00       	push   $0x1000
f010300f:	57                   	push   %edi
f0103010:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103016:	e8 c0 f7 ff ff       	call   f01027db <page_insert>
f010301b:	83 c4 10             	add    $0x10,%esp
f010301e:	85 c0                	test   %eax,%eax
f0103020:	74 14                	je     f0103036 <mem_init+0x800>
f0103022:	68 32 60 10 f0       	push   $0xf0106032
f0103027:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010302c:	68 9a 03 00 00       	push   $0x39a
f0103031:	e9 4e f9 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0103036:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010303b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103040:	e8 2d f2 ff ff       	call   f0102272 <check_va2pa>
f0103045:	89 c5                	mov    %eax,%ebp
f0103047:	89 f8                	mov    %edi,%eax
f0103049:	e8 9a f1 ff ff       	call   f01021e8 <page2pa>
f010304e:	39 c5                	cmp    %eax,%ebp
f0103050:	74 14                	je     f0103066 <mem_init+0x830>
f0103052:	68 b4 5f 10 f0       	push   $0xf0105fb4
f0103057:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010305c:	68 9b 03 00 00       	push   $0x39b
f0103061:	e9 1e f9 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2->pp_ref == 1);
f0103066:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010306b:	74 14                	je     f0103081 <mem_init+0x84b>
f010306d:	68 e4 5f 10 f0       	push   $0xf0105fe4
f0103072:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103077:	68 9c 03 00 00       	push   $0x39c
f010307c:	e9 03 f9 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0103081:	50                   	push   %eax
f0103082:	6a 00                	push   $0x0
f0103084:	68 00 10 00 00       	push   $0x1000
f0103089:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f010308f:	e8 f5 f5 ff ff       	call   f0102689 <pgdir_walk>
f0103094:	83 c4 10             	add    $0x10,%esp
f0103097:	f6 00 04             	testb  $0x4,(%eax)
f010309a:	75 14                	jne    f01030b0 <mem_init+0x87a>
f010309c:	68 71 60 10 f0       	push   $0xf0106071
f01030a1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01030a6:	68 9d 03 00 00       	push   $0x39d
f01030ab:	e9 d4 f8 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(kern_pgdir[0] & PTE_U);
f01030b0:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01030b5:	f6 00 04             	testb  $0x4,(%eax)
f01030b8:	75 14                	jne    f01030ce <mem_init+0x898>
f01030ba:	68 a4 60 10 f0       	push   $0xf01060a4
f01030bf:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01030c4:	68 9e 03 00 00       	push   $0x39e
f01030c9:	e9 b6 f8 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01030ce:	6a 02                	push   $0x2
f01030d0:	68 00 10 00 00       	push   $0x1000
f01030d5:	57                   	push   %edi
f01030d6:	50                   	push   %eax
f01030d7:	e8 ff f6 ff ff       	call   f01027db <page_insert>
f01030dc:	83 c4 10             	add    $0x10,%esp
f01030df:	85 c0                	test   %eax,%eax
f01030e1:	74 14                	je     f01030f7 <mem_init+0x8c1>
f01030e3:	68 7b 5f 10 f0       	push   $0xf0105f7b
f01030e8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01030ed:	68 a1 03 00 00       	push   $0x3a1
f01030f2:	e9 8d f8 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01030f7:	55                   	push   %ebp
f01030f8:	6a 00                	push   $0x0
f01030fa:	68 00 10 00 00       	push   $0x1000
f01030ff:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103105:	e8 7f f5 ff ff       	call   f0102689 <pgdir_walk>
f010310a:	83 c4 10             	add    $0x10,%esp
f010310d:	f6 00 02             	testb  $0x2,(%eax)
f0103110:	75 14                	jne    f0103126 <mem_init+0x8f0>
f0103112:	68 ba 60 10 f0       	push   $0xf01060ba
f0103117:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010311c:	68 a2 03 00 00       	push   $0x3a2
f0103121:	e9 5e f8 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0103126:	51                   	push   %ecx
f0103127:	6a 00                	push   $0x0
f0103129:	68 00 10 00 00       	push   $0x1000
f010312e:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103134:	e8 50 f5 ff ff       	call   f0102689 <pgdir_walk>
f0103139:	83 c4 10             	add    $0x10,%esp
f010313c:	f6 00 04             	testb  $0x4,(%eax)
f010313f:	74 14                	je     f0103155 <mem_init+0x91f>
f0103141:	68 ed 60 10 f0       	push   $0xf01060ed
f0103146:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010314b:	68 a3 03 00 00       	push   $0x3a3
f0103150:	e9 2f f8 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0103155:	6a 02                	push   $0x2
f0103157:	68 00 00 40 00       	push   $0x400000
f010315c:	56                   	push   %esi
f010315d:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103163:	e8 73 f6 ff ff       	call   f01027db <page_insert>
f0103168:	83 c4 10             	add    $0x10,%esp
f010316b:	85 c0                	test   %eax,%eax
f010316d:	78 14                	js     f0103183 <mem_init+0x94d>
f010316f:	68 23 61 10 f0       	push   $0xf0106123
f0103174:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103179:	68 a6 03 00 00       	push   $0x3a6
f010317e:	e9 01 f8 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0103183:	6a 02                	push   $0x2
f0103185:	68 00 10 00 00       	push   $0x1000
f010318a:	53                   	push   %ebx
f010318b:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103191:	e8 45 f6 ff ff       	call   f01027db <page_insert>
f0103196:	83 c4 10             	add    $0x10,%esp
f0103199:	85 c0                	test   %eax,%eax
f010319b:	74 14                	je     f01031b1 <mem_init+0x97b>
f010319d:	68 5b 61 10 f0       	push   $0xf010615b
f01031a2:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01031a7:	68 a9 03 00 00       	push   $0x3a9
f01031ac:	e9 d3 f7 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01031b1:	52                   	push   %edx
f01031b2:	6a 00                	push   $0x0
f01031b4:	68 00 10 00 00       	push   $0x1000
f01031b9:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01031bf:	e8 c5 f4 ff ff       	call   f0102689 <pgdir_walk>
f01031c4:	83 c4 10             	add    $0x10,%esp
f01031c7:	f6 00 04             	testb  $0x4,(%eax)
f01031ca:	74 14                	je     f01031e0 <mem_init+0x9aa>
f01031cc:	68 ed 60 10 f0       	push   $0xf01060ed
f01031d1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01031d6:	68 aa 03 00 00       	push   $0x3aa
f01031db:	e9 a4 f7 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01031e0:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01031e5:	31 d2                	xor    %edx,%edx
f01031e7:	e8 86 f0 ff ff       	call   f0102272 <check_va2pa>
f01031ec:	89 c5                	mov    %eax,%ebp
f01031ee:	89 d8                	mov    %ebx,%eax
f01031f0:	e8 f3 ef ff ff       	call   f01021e8 <page2pa>
f01031f5:	39 c5                	cmp    %eax,%ebp
f01031f7:	74 14                	je     f010320d <mem_init+0x9d7>
f01031f9:	68 94 61 10 f0       	push   $0xf0106194
f01031fe:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103203:	68 ad 03 00 00       	push   $0x3ad
f0103208:	e9 77 f7 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010320d:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103212:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103217:	e8 56 f0 ff ff       	call   f0102272 <check_va2pa>
f010321c:	89 c5                	mov    %eax,%ebp
f010321e:	89 d8                	mov    %ebx,%eax
f0103220:	e8 c3 ef ff ff       	call   f01021e8 <page2pa>
f0103225:	39 c5                	cmp    %eax,%ebp
f0103227:	74 14                	je     f010323d <mem_init+0xa07>
f0103229:	68 bf 61 10 f0       	push   $0xf01061bf
f010322e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103233:	68 ae 03 00 00       	push   $0x3ae
f0103238:	e9 47 f7 ff ff       	jmp    f0102984 <mem_init+0x14e>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f010323d:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0103242:	74 14                	je     f0103258 <mem_init+0xa22>
f0103244:	68 ef 61 10 f0       	push   $0xf01061ef
f0103249:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010324e:	68 b0 03 00 00       	push   $0x3b0
f0103253:	e9 2c f7 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2->pp_ref == 0);
f0103258:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010325d:	74 14                	je     f0103273 <mem_init+0xa3d>
f010325f:	68 00 62 10 f0       	push   $0xf0106200
f0103264:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103269:	68 b1 03 00 00       	push   $0x3b1
f010326e:	e9 11 f7 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0103273:	83 ec 0c             	sub    $0xc,%esp
f0103276:	6a 00                	push   $0x0
f0103278:	e8 49 f3 ff ff       	call   f01025c6 <page_alloc>
f010327d:	83 c4 10             	add    $0x10,%esp
f0103280:	85 c0                	test   %eax,%eax
f0103282:	89 c5                	mov    %eax,%ebp
f0103284:	74 04                	je     f010328a <mem_init+0xa54>
f0103286:	39 f8                	cmp    %edi,%eax
f0103288:	74 14                	je     f010329e <mem_init+0xa68>
f010328a:	68 11 62 10 f0       	push   $0xf0106211
f010328f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103294:	68 b4 03 00 00       	push   $0x3b4
f0103299:	e9 e6 f6 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f010329e:	50                   	push   %eax
f010329f:	50                   	push   %eax
f01032a0:	6a 00                	push   $0x0
f01032a2:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01032a8:	e8 e6 f4 ff ff       	call   f0102793 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01032ad:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01032b2:	31 d2                	xor    %edx,%edx
f01032b4:	e8 b9 ef ff ff       	call   f0102272 <check_va2pa>
f01032b9:	83 c4 10             	add    $0x10,%esp
f01032bc:	40                   	inc    %eax
f01032bd:	74 14                	je     f01032d3 <mem_init+0xa9d>
f01032bf:	68 33 62 10 f0       	push   $0xf0106233
f01032c4:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01032c9:	68 b8 03 00 00       	push   $0x3b8
f01032ce:	e9 b1 f6 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01032d3:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01032d8:	ba 00 10 00 00       	mov    $0x1000,%edx
f01032dd:	e8 90 ef ff ff       	call   f0102272 <check_va2pa>
f01032e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01032e6:	89 d8                	mov    %ebx,%eax
f01032e8:	e8 fb ee ff ff       	call   f01021e8 <page2pa>
f01032ed:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f01032f1:	74 14                	je     f0103307 <mem_init+0xad1>
f01032f3:	68 bf 61 10 f0       	push   $0xf01061bf
f01032f8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01032fd:	68 b9 03 00 00       	push   $0x3b9
f0103302:	e9 7d f6 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp1->pp_ref == 1);
f0103307:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010330c:	74 14                	je     f0103322 <mem_init+0xaec>
f010330e:	68 59 5f 10 f0       	push   $0xf0105f59
f0103313:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103318:	68 ba 03 00 00       	push   $0x3ba
f010331d:	e9 62 f6 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2->pp_ref == 0);
f0103322:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103327:	74 14                	je     f010333d <mem_init+0xb07>
f0103329:	68 00 62 10 f0       	push   $0xf0106200
f010332e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103333:	68 bb 03 00 00       	push   $0x3bb
f0103338:	e9 47 f6 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010333d:	6a 00                	push   $0x0
f010333f:	68 00 10 00 00       	push   $0x1000
f0103344:	53                   	push   %ebx
f0103345:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f010334b:	e8 8b f4 ff ff       	call   f01027db <page_insert>
f0103350:	83 c4 10             	add    $0x10,%esp
f0103353:	85 c0                	test   %eax,%eax
f0103355:	74 14                	je     f010336b <mem_init+0xb35>
f0103357:	68 56 62 10 f0       	push   $0xf0106256
f010335c:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103361:	68 be 03 00 00       	push   $0x3be
f0103366:	e9 19 f6 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp1->pp_ref);
f010336b:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103370:	75 14                	jne    f0103386 <mem_init+0xb50>
f0103372:	68 8b 62 10 f0       	push   $0xf010628b
f0103377:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010337c:	68 bf 03 00 00       	push   $0x3bf
f0103381:	e9 fe f5 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp1->pp_link == NULL);
f0103386:	83 3b 00             	cmpl   $0x0,(%ebx)
f0103389:	74 14                	je     f010339f <mem_init+0xb69>
f010338b:	68 97 62 10 f0       	push   $0xf0106297
f0103390:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103395:	68 c0 03 00 00       	push   $0x3c0
f010339a:	e9 e5 f5 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f010339f:	51                   	push   %ecx
f01033a0:	51                   	push   %ecx
f01033a1:	68 00 10 00 00       	push   $0x1000
f01033a6:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01033ac:	e8 e2 f3 ff ff       	call   f0102793 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01033b1:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01033b6:	31 d2                	xor    %edx,%edx
f01033b8:	e8 b5 ee ff ff       	call   f0102272 <check_va2pa>
f01033bd:	83 c4 10             	add    $0x10,%esp
f01033c0:	40                   	inc    %eax
f01033c1:	74 14                	je     f01033d7 <mem_init+0xba1>
f01033c3:	68 33 62 10 f0       	push   $0xf0106233
f01033c8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01033cd:	68 c4 03 00 00       	push   $0x3c4
f01033d2:	e9 ad f5 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01033d7:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01033dc:	ba 00 10 00 00       	mov    $0x1000,%edx
f01033e1:	e8 8c ee ff ff       	call   f0102272 <check_va2pa>
f01033e6:	40                   	inc    %eax
f01033e7:	74 14                	je     f01033fd <mem_init+0xbc7>
f01033e9:	68 ac 62 10 f0       	push   $0xf01062ac
f01033ee:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01033f3:	68 c5 03 00 00       	push   $0x3c5
f01033f8:	e9 87 f5 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp1->pp_ref == 0);
f01033fd:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103402:	74 14                	je     f0103418 <mem_init+0xbe2>
f0103404:	68 d2 62 10 f0       	push   $0xf01062d2
f0103409:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010340e:	68 c6 03 00 00       	push   $0x3c6
f0103413:	e9 6c f5 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2->pp_ref == 0);
f0103418:	66 83 7d 04 00       	cmpw   $0x0,0x4(%ebp)
f010341d:	74 14                	je     f0103433 <mem_init+0xbfd>
f010341f:	68 00 62 10 f0       	push   $0xf0106200
f0103424:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103429:	68 c7 03 00 00       	push   $0x3c7
f010342e:	e9 51 f5 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0103433:	83 ec 0c             	sub    $0xc,%esp
f0103436:	6a 00                	push   $0x0
f0103438:	e8 89 f1 ff ff       	call   f01025c6 <page_alloc>
f010343d:	83 c4 10             	add    $0x10,%esp
f0103440:	85 c0                	test   %eax,%eax
f0103442:	89 c7                	mov    %eax,%edi
f0103444:	74 04                	je     f010344a <mem_init+0xc14>
f0103446:	39 d8                	cmp    %ebx,%eax
f0103448:	74 14                	je     f010345e <mem_init+0xc28>
f010344a:	68 e3 62 10 f0       	push   $0xf01062e3
f010344f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103454:	68 ca 03 00 00       	push   $0x3ca
f0103459:	e9 26 f5 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// should be no free memory
	assert(!page_alloc(0));
f010345e:	83 ec 0c             	sub    $0xc,%esp
f0103461:	6a 00                	push   $0x0
f0103463:	e8 5e f1 ff ff       	call   f01025c6 <page_alloc>
f0103468:	83 c4 10             	add    $0x10,%esp
f010346b:	85 c0                	test   %eax,%eax
f010346d:	74 14                	je     f0103483 <mem_init+0xc4d>
f010346f:	68 03 5e 10 f0       	push   $0xf0105e03
f0103474:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103479:	68 cd 03 00 00       	push   $0x3cd
f010347e:	e9 01 f5 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103483:	8b 1d c8 76 11 f0    	mov    0xf01176c8,%ebx
f0103489:	89 f0                	mov    %esi,%eax
f010348b:	e8 58 ed ff ff       	call   f01021e8 <page2pa>
f0103490:	8b 13                	mov    (%ebx),%edx
f0103492:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0103498:	39 c2                	cmp    %eax,%edx
f010349a:	74 14                	je     f01034b0 <mem_init+0xc7a>
f010349c:	68 04 5f 10 f0       	push   $0xf0105f04
f01034a1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01034a6:	68 d0 03 00 00       	push   $0x3d0
f01034ab:	e9 d4 f4 ff ff       	jmp    f0102984 <mem_init+0x14e>
	kern_pgdir[0] = 0;
	assert(pp0->pp_ref == 1);
f01034b0:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
	// should be no free memory
	assert(!page_alloc(0));

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
	kern_pgdir[0] = 0;
f01034b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	assert(pp0->pp_ref == 1);
f01034bb:	74 14                	je     f01034d1 <mem_init+0xc9b>
f01034bd:	68 6a 5f 10 f0       	push   $0xf0105f6a
f01034c2:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01034c7:	68 d2 03 00 00       	push   $0x3d2
f01034cc:	e9 b3 f4 ff ff       	jmp    f0102984 <mem_init+0x14e>
	pp0->pp_ref = 0;

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01034d1:	83 ec 0c             	sub    $0xc,%esp

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
	kern_pgdir[0] = 0;
	assert(pp0->pp_ref == 1);
	pp0->pp_ref = 0;
f01034d4:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01034da:	56                   	push   %esi
f01034db:	e8 2d f1 ff ff       	call   f010260d <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01034e0:	83 c4 0c             	add    $0xc,%esp
f01034e3:	6a 01                	push   $0x1
f01034e5:	68 00 10 40 00       	push   $0x401000
f01034ea:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01034f0:	e8 94 f1 ff ff       	call   f0102689 <pgdir_walk>
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01034f5:	ba d9 03 00 00       	mov    $0x3d9,%edx
	pp0->pp_ref = 0;

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01034fa:	89 44 24 2c          	mov    %eax,0x2c(%esp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01034fe:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103503:	8b 48 04             	mov    0x4(%eax),%ecx
f0103506:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
f010350b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103511:	e8 1a ed ff ff       	call   f0102230 <_kaddr>
	assert(ptep == ptep1 + PTX(va));
f0103516:	83 c4 10             	add    $0x10,%esp
f0103519:	83 c0 04             	add    $0x4,%eax
f010351c:	39 44 24 1c          	cmp    %eax,0x1c(%esp)
f0103520:	74 14                	je     f0103536 <mem_init+0xd00>
f0103522:	68 05 63 10 f0       	push   $0xf0106305
f0103527:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010352c:	68 da 03 00 00       	push   $0x3da
f0103531:	e9 4e f4 ff ff       	jmp    f0102984 <mem_init+0x14e>
	kern_pgdir[PDX(va)] = 0;
f0103536:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010353b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0103542:	89 f0                	mov    %esi,%eax
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
	assert(ptep == ptep1 + PTX(va));
	kern_pgdir[PDX(va)] = 0;
	pp0->pp_ref = 0;
f0103544:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f010354a:	e8 0a ed ff ff       	call   f0102259 <page2kva>
f010354f:	52                   	push   %edx
f0103550:	68 00 10 00 00       	push   $0x1000
f0103555:	68 ff 00 00 00       	push   $0xff
f010355a:	50                   	push   %eax
f010355b:	e8 6f cc ff ff       	call   f01001cf <memset>
	page_free(pp0);
f0103560:	89 34 24             	mov    %esi,(%esp)
f0103563:	e8 a5 f0 ff ff       	call   f010260d <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0103568:	83 c4 0c             	add    $0xc,%esp
f010356b:	6a 01                	push   $0x1
f010356d:	6a 00                	push   $0x0
f010356f:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103575:	e8 0f f1 ff ff       	call   f0102689 <pgdir_walk>
	ptep = (pte_t *) page2kva(pp0);
f010357a:	89 f0                	mov    %esi,%eax
f010357c:	e8 d8 ec ff ff       	call   f0102259 <page2kva>
	for(i=0; i<NPTENTRIES; i++)
f0103581:	31 d2                	xor    %edx,%edx

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
f0103583:	89 44 24 2c          	mov    %eax,0x2c(%esp)
f0103587:	83 c4 10             	add    $0x10,%esp
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f010358a:	f6 04 90 01          	testb  $0x1,(%eax,%edx,4)
f010358e:	74 14                	je     f01035a4 <mem_init+0xd6e>
f0103590:	68 1d 63 10 f0       	push   $0xf010631d
f0103595:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010359a:	68 e4 03 00 00       	push   $0x3e4
f010359f:	e9 e0 f3 ff ff       	jmp    f0102984 <mem_init+0x14e>
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f01035a4:	42                   	inc    %edx
f01035a5:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f01035ab:	75 dd                	jne    f010358a <mem_init+0xd54>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f01035ad:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01035b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;

	// give free list back
	page_free_list = fl;
f01035b8:	8b 44 24 08          	mov    0x8(%esp),%eax

	// free the pages we took
	page_free(pp0);
f01035bc:	83 ec 0c             	sub    $0xc,%esp
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
	pp0->pp_ref = 0;
f01035bf:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// give free list back
	page_free_list = fl;

	// free the pages we took
	page_free(pp0);
f01035c5:	56                   	push   %esi
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
	pp0->pp_ref = 0;

	// give free list back
	page_free_list = fl;
f01035c6:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c

	// free the pages we took
	page_free(pp0);
f01035cb:	e8 3d f0 ff ff       	call   f010260d <page_free>
	page_free(pp1);
f01035d0:	89 3c 24             	mov    %edi,(%esp)
f01035d3:	e8 35 f0 ff ff       	call   f010260d <page_free>
	page_free(pp2);
f01035d8:	89 2c 24             	mov    %ebp,(%esp)
f01035db:	e8 2d f0 ff ff       	call   f010260d <page_free>

	printk("check_page() succeeded!\n");
f01035e0:	c7 04 24 34 63 10 f0 	movl   $0xf0106334,(%esp)
f01035e7:	e8 e4 eb ff ff       	call   f01021d0 <printk>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	boot_map_region(kern_pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f01035ec:	8b 15 d0 76 11 f0    	mov    0xf01176d0,%edx
f01035f2:	b8 b5 00 00 00       	mov    $0xb5,%eax
f01035f7:	e8 27 ef ff ff       	call   f0102523 <_paddr.clone.0>
f01035fc:	8b 15 c4 76 11 f0    	mov    0xf01176c4,%edx
f0103602:	5b                   	pop    %ebx
f0103603:	5e                   	pop    %esi
f0103604:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f010360b:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103610:	6a 05                	push   $0x5
f0103612:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103618:	50                   	push   %eax
f0103619:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010361e:	e8 cf f0 ff ff       	call   f01026f2 <boot_map_region>
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    	extern char bootstack[];
    	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR((char *)bootstack), (PTE_W | PTE_P));
f0103623:	ba 00 c0 10 f0       	mov    $0xf010c000,%edx
f0103628:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010362d:	e8 f1 ee ff ff       	call   f0102523 <_paddr.clone.0>
f0103632:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103637:	5d                   	pop    %ebp
f0103638:	5a                   	pop    %edx
f0103639:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010363e:	6a 03                	push   $0x3
f0103640:	50                   	push   %eax
f0103641:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103646:	e8 a7 f0 ff ff       	call   f01026f2 <boot_map_region>
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    	
	boot_map_region(kern_pgdir, KERNBASE ,  (0x100000 - PGNUM(KERNBASE)) << 12,0x00, (PTE_W | PTE_P));
f010364b:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103650:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0103655:	5e                   	pop    %esi
f0103656:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f010365b:	5f                   	pop    %edi
	pde_t *pgdir;

	pgdir = kern_pgdir;

   	 // check IO mem
    	for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
f010365c:	be 00 00 0a 00       	mov    $0xa0000,%esi
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    	
	boot_map_region(kern_pgdir, KERNBASE ,  (0x100000 - PGNUM(KERNBASE)) << 12,0x00, (PTE_W | PTE_P));
f0103661:	6a 03                	push   $0x3
f0103663:	6a 00                	push   $0x0
f0103665:	e8 88 f0 ff ff       	call   f01026f2 <boot_map_region>


	//////////////////////////////////////////////////////////////////////
	// Map VA range [IOPHYSMEM, EXTPHYSMEM) to PA range [IOPHYSMEM, EXTPHYSMEM)
	boot_map_region(kern_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f010366a:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010366f:	ba 00 00 0a 00       	mov    $0xa0000,%edx
f0103674:	59                   	pop    %ecx
f0103675:	b9 00 00 06 00       	mov    $0x60000,%ecx
f010367a:	5b                   	pop    %ebx
f010367b:	6a 03                	push   $0x3
f010367d:	68 00 00 0a 00       	push   $0xa0000
f0103682:	e8 6b f0 ff ff       	call   f01026f2 <boot_map_region>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0103687:	8b 1d c8 76 11 f0    	mov    0xf01176c8,%ebx
f010368d:	83 c4 10             	add    $0x10,%esp

   	 // check IO mem
    	for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);
f0103690:	89 f2                	mov    %esi,%edx
f0103692:	89 d8                	mov    %ebx,%eax
f0103694:	e8 d9 eb ff ff       	call   f0102272 <check_va2pa>
f0103699:	39 f0                	cmp    %esi,%eax
f010369b:	74 14                	je     f01036b1 <mem_init+0xe7b>
f010369d:	68 4d 63 10 f0       	push   $0xf010634d
f01036a2:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01036a7:	68 22 03 00 00       	push   $0x322
f01036ac:	e9 d3 f2 ff ff       	jmp    f0102984 <mem_init+0x14e>
	pde_t *pgdir;

	pgdir = kern_pgdir;

   	 // check IO mem
    	for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
f01036b1:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01036b7:	81 fe 00 00 10 00    	cmp    $0x100000,%esi
f01036bd:	75 d1                	jne    f0103690 <mem_init+0xe5a>
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01036bf:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
	for (i = 0; i < n; i += PGSIZE)
f01036c4:	31 f6                	xor    %esi,%esi
   	 // check IO mem
    	for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01036c6:	8d 3c c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%edi
f01036cd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
f01036d3:	eb 3f                	jmp    f0103714 <mem_init+0xede>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01036d5:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f01036db:	89 d8                	mov    %ebx,%eax
f01036dd:	e8 90 eb ff ff       	call   f0102272 <check_va2pa>
f01036e2:	8b 15 d0 76 11 f0    	mov    0xf01176d0,%edx
f01036e8:	89 c5                	mov    %eax,%ebp
f01036ea:	b8 27 03 00 00       	mov    $0x327,%eax
f01036ef:	e8 2f ee ff ff       	call   f0102523 <_paddr.clone.0>
f01036f4:	01 f0                	add    %esi,%eax
f01036f6:	39 c5                	cmp    %eax,%ebp
f01036f8:	74 14                	je     f010370e <mem_init+0xed8>
f01036fa:	68 68 63 10 f0       	push   $0xf0106368
f01036ff:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103704:	68 27 03 00 00       	push   $0x327
f0103709:	e9 76 f2 ff ff       	jmp    f0102984 <mem_init+0x14e>
    	for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f010370e:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103714:	39 fe                	cmp    %edi,%esi
f0103716:	72 bd                	jb     f01036d5 <mem_init+0xe9f>
f0103718:	31 f6                	xor    %esi,%esi
f010371a:	eb 2b                	jmp    f0103747 <mem_init+0xf11>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
    
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010371c:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f0103722:	89 d8                	mov    %ebx,%eax
f0103724:	e8 49 eb ff ff       	call   f0102272 <check_va2pa>
f0103729:	39 f0                	cmp    %esi,%eax
f010372b:	74 14                	je     f0103741 <mem_init+0xf0b>
f010372d:	68 9b 63 10 f0       	push   $0xf010639b
f0103732:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103737:	68 2b 03 00 00       	push   $0x32b
f010373c:	e9 43 f2 ff ff       	jmp    f0102984 <mem_init+0x14e>
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
    
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103741:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103747:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f010374c:	c1 e0 0c             	shl    $0xc,%eax
f010374f:	39 c6                	cmp    %eax,%esi
f0103751:	72 c9                	jb     f010371c <mem_init+0xee6>
f0103753:	31 f6                	xor    %esi,%esi
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0103755:	8d 96 00 80 ff ef    	lea    -0x10008000(%esi),%edx
f010375b:	89 d8                	mov    %ebx,%eax
f010375d:	e8 10 eb ff ff       	call   f0102272 <check_va2pa>
f0103762:	ba 00 c0 10 f0       	mov    $0xf010c000,%edx
f0103767:	89 c7                	mov    %eax,%edi
f0103769:	b8 2f 03 00 00       	mov    $0x32f,%eax
f010376e:	e8 b0 ed ff ff       	call   f0102523 <_paddr.clone.0>
f0103773:	8d 04 06             	lea    (%esi,%eax,1),%eax
f0103776:	39 c7                	cmp    %eax,%edi
f0103778:	74 14                	je     f010378e <mem_init+0xf58>
f010377a:	68 c1 63 10 f0       	push   $0xf01063c1
f010377f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103784:	68 2f 03 00 00       	push   $0x32f
f0103789:	e9 f6 f1 ff ff       	jmp    f0102984 <mem_init+0x14e>
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f010378e:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103794:	81 fe 00 80 00 00    	cmp    $0x8000,%esi
f010379a:	75 b9                	jne    f0103755 <mem_init+0xf1f>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f010379c:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f01037a1:	89 d8                	mov    %ebx,%eax
f01037a3:	e8 ca ea ff ff       	call   f0102272 <check_va2pa>
f01037a8:	31 d2                	xor    %edx,%edx
f01037aa:	40                   	inc    %eax
f01037ab:	74 14                	je     f01037c1 <mem_init+0xf8b>
f01037ad:	68 06 64 10 f0       	push   $0xf0106406
f01037b2:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01037b7:	68 30 03 00 00       	push   $0x330
f01037bc:	e9 c3 f1 ff ff       	jmp    f0102984 <mem_init+0x14e>

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f01037c1:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
f01037c7:	77 0c                	ja     f01037d5 <mem_init+0xf9f>
f01037c9:	81 fa bc 03 00 00    	cmp    $0x3bc,%edx
f01037cf:	73 0c                	jae    f01037dd <mem_init+0xfa7>
f01037d1:	85 d2                	test   %edx,%edx
f01037d3:	eb 06                	jmp    f01037db <mem_init+0xfa5>
f01037d5:	81 fa bf 03 00 00    	cmp    $0x3bf,%edx
f01037db:	75 1a                	jne    f01037f7 <mem_init+0xfc1>
        case PDX(IOPHYSMEM):
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
			assert(pgdir[i] & PTE_P);
f01037dd:	f6 04 93 01          	testb  $0x1,(%ebx,%edx,4)
f01037e1:	75 69                	jne    f010384c <mem_init+0x1016>
f01037e3:	68 33 64 10 f0       	push   $0xf0106433
f01037e8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01037ed:	68 39 03 00 00       	push   $0x339
f01037f2:	e9 8d f1 ff ff       	jmp    f0102984 <mem_init+0x14e>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f01037f7:	81 fa bf 03 00 00    	cmp    $0x3bf,%edx
f01037fd:	76 33                	jbe    f0103832 <mem_init+0xffc>
				assert(pgdir[i] & PTE_P);
f01037ff:	8b 04 93             	mov    (%ebx,%edx,4),%eax
f0103802:	a8 01                	test   $0x1,%al
f0103804:	75 14                	jne    f010381a <mem_init+0xfe4>
f0103806:	68 33 64 10 f0       	push   $0xf0106433
f010380b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103810:	68 3d 03 00 00       	push   $0x33d
f0103815:	e9 6a f1 ff ff       	jmp    f0102984 <mem_init+0x14e>
				assert(pgdir[i] & PTE_W);
f010381a:	a8 02                	test   $0x2,%al
f010381c:	75 2e                	jne    f010384c <mem_init+0x1016>
f010381e:	68 44 64 10 f0       	push   $0xf0106444
f0103823:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103828:	68 3e 03 00 00       	push   $0x33e
f010382d:	e9 52 f1 ff ff       	jmp    f0102984 <mem_init+0x14e>
			} else
				assert(pgdir[i] == 0);
f0103832:	83 3c 93 00          	cmpl   $0x0,(%ebx,%edx,4)
f0103836:	74 14                	je     f010384c <mem_init+0x1016>
f0103838:	68 55 64 10 f0       	push   $0xf0106455
f010383d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103842:	68 40 03 00 00       	push   $0x340
f0103847:	e9 38 f1 ff ff       	jmp    f0102984 <mem_init+0x14e>
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f010384c:	42                   	inc    %edx
f010384d:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f0103853:	0f 85 68 ff ff ff    	jne    f01037c1 <mem_init+0xf8b>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	printk("check_kern_pgdir() succeeded!\n");
f0103859:	83 ec 0c             	sub    $0xc,%esp
f010385c:	68 63 64 10 f0       	push   $0xf0106463
f0103861:	e8 6a e9 ff ff       	call   f01021d0 <printk>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f0103866:	8b 15 c8 76 11 f0    	mov    0xf01176c8,%edx
f010386c:	b8 e1 00 00 00       	mov    $0xe1,%eax
f0103871:	e8 ad ec ff ff       	call   f0102523 <_paddr.clone.0>
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103876:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f0103879:	31 c0                	xor    %eax,%eax
f010387b:	e8 6a ea ff ff       	call   f01022ea <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0103880:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
f0103883:	0d 23 00 05 80       	or     $0x80050023,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103888:	83 e0 f3             	and    $0xfffffff3,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f010388b:	0f 22 c0             	mov    %eax,%cr0
{
	struct PageInfo *pp0, *pp1, *pp2;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f010388e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103895:	e8 2c ed ff ff       	call   f01025c6 <page_alloc>
f010389a:	83 c4 10             	add    $0x10,%esp
f010389d:	85 c0                	test   %eax,%eax
f010389f:	89 c7                	mov    %eax,%edi
f01038a1:	75 14                	jne    f01038b7 <mem_init+0x1081>
f01038a3:	68 38 5d 10 f0       	push   $0xf0105d38
f01038a8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01038ad:	68 fb 03 00 00       	push   $0x3fb
f01038b2:	e9 cd f0 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert((pp1 = page_alloc(0)));
f01038b7:	83 ec 0c             	sub    $0xc,%esp
f01038ba:	6a 00                	push   $0x0
f01038bc:	e8 05 ed ff ff       	call   f01025c6 <page_alloc>
f01038c1:	83 c4 10             	add    $0x10,%esp
f01038c4:	85 c0                	test   %eax,%eax
f01038c6:	89 c6                	mov    %eax,%esi
f01038c8:	75 14                	jne    f01038de <mem_init+0x10a8>
f01038ca:	68 4e 5d 10 f0       	push   $0xf0105d4e
f01038cf:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01038d4:	68 fc 03 00 00       	push   $0x3fc
f01038d9:	e9 a6 f0 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert((pp2 = page_alloc(0)));
f01038de:	83 ec 0c             	sub    $0xc,%esp
f01038e1:	6a 00                	push   $0x0
f01038e3:	e8 de ec ff ff       	call   f01025c6 <page_alloc>
f01038e8:	83 c4 10             	add    $0x10,%esp
f01038eb:	85 c0                	test   %eax,%eax
f01038ed:	89 c3                	mov    %eax,%ebx
f01038ef:	75 14                	jne    f0103905 <mem_init+0x10cf>
f01038f1:	68 64 5d 10 f0       	push   $0xf0105d64
f01038f6:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01038fb:	68 fd 03 00 00       	push   $0x3fd
f0103900:	e9 7f f0 ff ff       	jmp    f0102984 <mem_init+0x14e>
	page_free(pp0);
f0103905:	83 ec 0c             	sub    $0xc,%esp
f0103908:	57                   	push   %edi
f0103909:	e8 ff ec ff ff       	call   f010260d <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f010390e:	89 f0                	mov    %esi,%eax
f0103910:	e8 44 e9 ff ff       	call   f0102259 <page2kva>
f0103915:	83 c4 0c             	add    $0xc,%esp
f0103918:	68 00 10 00 00       	push   $0x1000
f010391d:	6a 01                	push   $0x1
f010391f:	50                   	push   %eax
f0103920:	e8 aa c8 ff ff       	call   f01001cf <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f0103925:	89 d8                	mov    %ebx,%eax
f0103927:	e8 2d e9 ff ff       	call   f0102259 <page2kva>
f010392c:	83 c4 0c             	add    $0xc,%esp
f010392f:	68 00 10 00 00       	push   $0x1000
f0103934:	6a 02                	push   $0x2
f0103936:	50                   	push   %eax
f0103937:	e8 93 c8 ff ff       	call   f01001cf <memset>
	page_insert(kern_pgdir, pp1, (void*) EXTPHYSMEM, PTE_W);
f010393c:	6a 02                	push   $0x2
f010393e:	68 00 00 10 00       	push   $0x100000
f0103943:	56                   	push   %esi
f0103944:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f010394a:	e8 8c ee ff ff       	call   f01027db <page_insert>
	assert(pp1->pp_ref == 1);
f010394f:	83 c4 20             	add    $0x20,%esp
f0103952:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103957:	74 14                	je     f010396d <mem_init+0x1137>
f0103959:	68 59 5f 10 f0       	push   $0xf0105f59
f010395e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103963:	68 02 04 00 00       	push   $0x402
f0103968:	e9 17 f0 ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(*(uint32_t *)EXTPHYSMEM == 0x01010101U);
f010396d:	81 3d 00 00 10 00 01 	cmpl   $0x1010101,0x100000
f0103974:	01 01 01 
f0103977:	74 14                	je     f010398d <mem_init+0x1157>
f0103979:	68 82 64 10 f0       	push   $0xf0106482
f010397e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103983:	68 03 04 00 00       	push   $0x403
f0103988:	e9 f7 ef ff ff       	jmp    f0102984 <mem_init+0x14e>
	page_insert(kern_pgdir, pp2, (void*) EXTPHYSMEM, PTE_W);
f010398d:	6a 02                	push   $0x2
f010398f:	68 00 00 10 00       	push   $0x100000
f0103994:	53                   	push   %ebx
f0103995:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f010399b:	e8 3b ee ff ff       	call   f01027db <page_insert>
	assert(*(uint32_t *)EXTPHYSMEM == 0x02020202U);
f01039a0:	83 c4 10             	add    $0x10,%esp
f01039a3:	81 3d 00 00 10 00 02 	cmpl   $0x2020202,0x100000
f01039aa:	02 02 02 
f01039ad:	74 14                	je     f01039c3 <mem_init+0x118d>
f01039af:	68 a9 64 10 f0       	push   $0xf01064a9
f01039b4:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01039b9:	68 05 04 00 00       	push   $0x405
f01039be:	e9 c1 ef ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp2->pp_ref == 1);
f01039c3:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01039c8:	74 14                	je     f01039de <mem_init+0x11a8>
f01039ca:	68 e4 5f 10 f0       	push   $0xf0105fe4
f01039cf:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01039d4:	68 06 04 00 00       	push   $0x406
f01039d9:	e9 a6 ef ff ff       	jmp    f0102984 <mem_init+0x14e>
	assert(pp1->pp_ref == 0);
f01039de:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01039e3:	74 14                	je     f01039f9 <mem_init+0x11c3>
f01039e5:	68 d2 62 10 f0       	push   $0xf01062d2
f01039ea:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01039ef:	68 07 04 00 00       	push   $0x407
f01039f4:	e9 8b ef ff ff       	jmp    f0102984 <mem_init+0x14e>
	*(uint32_t *)EXTPHYSMEM = 0x03030303U;
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01039f9:	89 d8                	mov    %ebx,%eax
	assert(*(uint32_t *)EXTPHYSMEM == 0x01010101U);
	page_insert(kern_pgdir, pp2, (void*) EXTPHYSMEM, PTE_W);
	assert(*(uint32_t *)EXTPHYSMEM == 0x02020202U);
	assert(pp2->pp_ref == 1);
	assert(pp1->pp_ref == 0);
	*(uint32_t *)EXTPHYSMEM = 0x03030303U;
f01039fb:	c7 05 00 00 10 00 03 	movl   $0x3030303,0x100000
f0103a02:	03 03 03 
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103a05:	e8 4f e8 ff ff       	call   f0102259 <page2kva>
f0103a0a:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f0103a10:	74 14                	je     f0103a26 <mem_init+0x11f0>
f0103a12:	68 d0 64 10 f0       	push   $0xf01064d0
f0103a17:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103a1c:	68 09 04 00 00       	push   $0x409
f0103a21:	e9 5e ef ff ff       	jmp    f0102984 <mem_init+0x14e>
	page_remove(kern_pgdir, (void*) EXTPHYSMEM);
f0103a26:	52                   	push   %edx
f0103a27:	52                   	push   %edx
f0103a28:	68 00 00 10 00       	push   $0x100000
f0103a2d:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103a33:	e8 5b ed ff ff       	call   f0102793 <page_remove>
	assert(pp2->pp_ref == 0);
f0103a38:	83 c4 10             	add    $0x10,%esp
f0103a3b:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103a40:	74 14                	je     f0103a56 <mem_init+0x1220>
f0103a42:	68 00 62 10 f0       	push   $0xf0106200
f0103a47:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103a4c:	68 0b 04 00 00       	push   $0x40b
f0103a51:	e9 2e ef ff ff       	jmp    f0102984 <mem_init+0x14e>

	printk("check_page_installed_pgdir() succeeded!\n");
f0103a56:	83 ec 0c             	sub    $0xc,%esp
f0103a59:	68 fa 64 10 f0       	push   $0xf01064fa
f0103a5e:	e8 6d e7 ff ff       	call   f01021d0 <printk>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f0103a63:	83 c4 3c             	add    $0x3c,%esp
f0103a66:	5b                   	pop    %ebx
f0103a67:	5e                   	pop    %esi
f0103a68:	5f                   	pop    %edi
f0103a69:	5d                   	pop    %ebp
f0103a6a:	c3                   	ret    

f0103a6b <ptable_remove>:
	return;
}

void
ptable_remove(pde_t *pgdir)
{
f0103a6b:	56                   	push   %esi
f0103a6c:	53                   	push   %ebx
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
f0103a6d:	31 db                	xor    %ebx,%ebx
	return;
}

void
ptable_remove(pde_t *pgdir)
{
f0103a6f:	83 ec 04             	sub    $0x4,%esp
f0103a72:	8b 74 24 10          	mov    0x10(%esp),%esi
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
  {
    if (pgdir[i] & PTE_P)
f0103a76:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
f0103a79:	a8 01                	test   $0x1,%al
f0103a7b:	74 16                	je     f0103a93 <ptable_remove+0x28>
      page_decref(pa2page(PTE_ADDR(pgdir[i])));
f0103a7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103a82:	e8 36 e8 ff ff       	call   f01022bd <pa2page>
f0103a87:	83 ec 0c             	sub    $0xc,%esp
f0103a8a:	50                   	push   %eax
f0103a8b:	e8 d9 eb ff ff       	call   f0102669 <page_decref>
f0103a90:	83 c4 10             	add    $0x10,%esp
void
ptable_remove(pde_t *pgdir)
{
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
f0103a93:	43                   	inc    %ebx
f0103a94:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103a9a:	75 da                	jne    f0103a76 <ptable_remove+0xb>
  {
    if (pgdir[i] & PTE_P)
      page_decref(pa2page(PTE_ADDR(pgdir[i])));
  }
}
f0103a9c:	83 c4 04             	add    $0x4,%esp
f0103a9f:	5b                   	pop    %ebx
f0103aa0:	5e                   	pop    %esi
f0103aa1:	c3                   	ret    

f0103aa2 <pgdir_remove>:


void
pgdir_remove(pde_t *pgdir)
{
f0103aa2:	83 ec 0c             	sub    $0xc,%esp
  page_free(pa2page(PADDR(pgdir)));
f0103aa5:	b8 32 02 00 00       	mov    $0x232,%eax
f0103aaa:	8b 54 24 10          	mov    0x10(%esp),%edx
f0103aae:	e8 70 ea ff ff       	call   f0102523 <_paddr.clone.0>
f0103ab3:	e8 05 e8 ff ff       	call   f01022bd <pa2page>
f0103ab8:	89 44 24 10          	mov    %eax,0x10(%esp)
}
f0103abc:	83 c4 0c             	add    $0xc,%esp


void
pgdir_remove(pde_t *pgdir)
{
  page_free(pa2page(PADDR(pgdir)));
f0103abf:	e9 49 eb ff ff       	jmp    f010260d <page_free>

f0103ac4 <tlb_invalidate>:
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0103ac4:	8b 44 24 08          	mov    0x8(%esp),%eax
f0103ac8:	0f 01 38             	invlpg (%eax)
tlb_invalidate(pde_t *pgdir, void *va)
{
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
f0103acb:	c3                   	ret    

f0103acc <my_page_fault_handler>:

void my_page_fault_handler()
{
f0103acc:	83 ec 14             	sub    $0x14,%esp
	uint32_t cr2;
	__asm __volatile("movl %%cr2,%0\n": "=r"(cr2));
f0103acf:	0f 20 d0             	mov    %cr2,%eax
	cprintf("[0456071] Page fault @ 0x%x\n",cr2);
f0103ad2:	50                   	push   %eax
f0103ad3:	68 23 65 10 f0       	push   $0xf0106523
f0103ad8:	e8 fa c9 ff ff       	call   f01004d7 <cprintf>
f0103add:	83 c4 10             	add    $0x10,%esp
f0103ae0:	eb fe                	jmp    f0103ae0 <my_page_fault_handler+0x14>

f0103ae2 <setupvm>:
}

/* This is a simple wrapper function for mapping user program */
void
setupvm(pde_t *pgdir, uint32_t start, uint32_t size)
{
f0103ae2:	56                   	push   %esi
  boot_map_region(pgdir, start, ROUNDUP(size, PGSIZE), PADDR((void*)start), PTE_W | PTE_U);
f0103ae3:	b8 4d 02 00 00       	mov    $0x24d,%eax
}

/* This is a simple wrapper function for mapping user program */
void
setupvm(pde_t *pgdir, uint32_t start, uint32_t size)
{
f0103ae8:	53                   	push   %ebx
f0103ae9:	83 ec 04             	sub    $0x4,%esp
f0103aec:	8b 5c 24 14          	mov    0x14(%esp),%ebx
f0103af0:	8b 74 24 10          	mov    0x10(%esp),%esi
  boot_map_region(pgdir, start, ROUNDUP(size, PGSIZE), PADDR((void*)start), PTE_W | PTE_U);
f0103af4:	89 da                	mov    %ebx,%edx
f0103af6:	e8 28 ea ff ff       	call   f0102523 <_paddr.clone.0>
f0103afb:	8b 4c 24 18          	mov    0x18(%esp),%ecx
f0103aff:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0103b05:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103b0b:	52                   	push   %edx
f0103b0c:	52                   	push   %edx
f0103b0d:	89 da                	mov    %ebx,%edx
f0103b0f:	6a 06                	push   $0x6
f0103b11:	50                   	push   %eax
f0103b12:	89 f0                	mov    %esi,%eax
f0103b14:	e8 d9 eb ff ff       	call   f01026f2 <boot_map_region>
  assert(check_va2pa(pgdir, start) == PADDR((void*)start));
f0103b19:	89 da                	mov    %ebx,%edx
f0103b1b:	89 f0                	mov    %esi,%eax
f0103b1d:	e8 50 e7 ff ff       	call   f0102272 <check_va2pa>
f0103b22:	89 da                	mov    %ebx,%edx
f0103b24:	89 c6                	mov    %eax,%esi
f0103b26:	b8 4e 02 00 00       	mov    $0x24e,%eax
f0103b2b:	e8 f3 e9 ff ff       	call   f0102523 <_paddr.clone.0>
f0103b30:	83 c4 10             	add    $0x10,%esp
f0103b33:	39 c6                	cmp    %eax,%esi
f0103b35:	74 19                	je     f0103b50 <setupvm+0x6e>
f0103b37:	68 40 65 10 f0       	push   $0xf0106540
f0103b3c:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103b41:	68 4e 02 00 00       	push   $0x24e
f0103b46:	68 ce 5a 10 f0       	push   $0xf0105ace
f0103b4b:	e8 f0 00 00 00       	call   f0103c40 <_panic>
}
f0103b50:	83 c4 04             	add    $0x4,%esp
f0103b53:	5b                   	pop    %ebx
f0103b54:	5e                   	pop    %esi
f0103b55:	c3                   	ret    

f0103b56 <setupkvm>:
 * You should map the kernel part memory with appropriate permission
 * Return a pointer to newly created page directory
 */
pde_t *
setupkvm()
{
f0103b56:	53                   	push   %ebx
f0103b57:	83 ec 14             	sub    $0x14,%esp
	pde_t *ret;
	struct PageInfo *pde_pp;

	pde_pp = page_alloc(1);
f0103b5a:	6a 01                	push   $0x1
f0103b5c:	e8 65 ea ff ff       	call   f01025c6 <page_alloc>
	if(!pde_pp)
f0103b61:	83 c4 10             	add    $0x10,%esp
f0103b64:	85 c0                	test   %eax,%eax
f0103b66:	75 15                	jne    f0103b7d <setupkvm+0x27>
		panic("No MEM in setupkvm\n");
f0103b68:	51                   	push   %ecx
f0103b69:	68 71 65 10 f0       	push   $0xf0106571
f0103b6e:	68 5f 02 00 00       	push   $0x25f
f0103b73:	68 ce 5a 10 f0       	push   $0xf0105ace
f0103b78:	e8 c3 00 00 00       	call   f0103c40 <_panic>
	pde_pp->pp_ref++;
f0103b7d:	66 ff 40 04          	incw   0x4(%eax)
	
	ret = page2kva(pde_pp);
f0103b81:	e8 d3 e6 ff ff       	call   f0102259 <page2kva>
		
	//memcpy(ret, kern_pgdir, PGSIZE);
	boot_map_region(ret, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f0103b86:	8b 15 d0 76 11 f0    	mov    0xf01176d0,%edx
	pde_pp = page_alloc(1);
	if(!pde_pp)
		panic("No MEM in setupkvm\n");
	pde_pp->pp_ref++;
	
	ret = page2kva(pde_pp);
f0103b8c:	89 c3                	mov    %eax,%ebx
		
	//memcpy(ret, kern_pgdir, PGSIZE);
	boot_map_region(ret, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f0103b8e:	b8 65 02 00 00       	mov    $0x265,%eax
f0103b93:	e8 8b e9 ff ff       	call   f0102523 <_paddr.clone.0>
f0103b98:	8b 15 c4 76 11 f0    	mov    0xf01176c4,%edx
f0103b9e:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f0103ba5:	52                   	push   %edx
f0103ba6:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103bac:	52                   	push   %edx
f0103bad:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103bb2:	6a 05                	push   $0x5
f0103bb4:	50                   	push   %eax
f0103bb5:	89 d8                	mov    %ebx,%eax
f0103bb7:	e8 36 eb ff ff       	call   f01026f2 <boot_map_region>

    	extern char bootstack[];
    	boot_map_region(ret, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR((char *)bootstack), (PTE_W | PTE_P));
f0103bbc:	ba 00 c0 10 f0       	mov    $0xf010c000,%edx
f0103bc1:	b8 68 02 00 00       	mov    $0x268,%eax
f0103bc6:	e8 58 e9 ff ff       	call   f0102523 <_paddr.clone.0>
f0103bcb:	5a                   	pop    %edx
f0103bcc:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103bd1:	59                   	pop    %ecx
f0103bd2:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103bd7:	6a 03                	push   $0x3
f0103bd9:	50                   	push   %eax
f0103bda:	89 d8                	mov    %ebx,%eax
f0103bdc:	e8 11 eb ff ff       	call   f01026f2 <boot_map_region>
	
	boot_map_region(ret, KERNBASE ,  (0x100000 - PGNUM(KERNBASE)) << 12,0x00, (PTE_W | PTE_P));
f0103be1:	89 d8                	mov    %ebx,%eax
f0103be3:	5a                   	pop    %edx
f0103be4:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103be9:	59                   	pop    %ecx
f0103bea:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0103bef:	6a 03                	push   $0x3
f0103bf1:	6a 00                	push   $0x0
f0103bf3:	e8 fa ea ff ff       	call   f01026f2 <boot_map_region>

	boot_map_region(ret, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f0103bf8:	ba 00 00 0a 00       	mov    $0xa0000,%edx
f0103bfd:	59                   	pop    %ecx
f0103bfe:	b9 00 00 06 00       	mov    $0x60000,%ecx
f0103c03:	58                   	pop    %eax
f0103c04:	89 d8                	mov    %ebx,%eax
f0103c06:	6a 03                	push   $0x3
f0103c08:	68 00 00 0a 00       	push   $0xa0000
f0103c0d:	e8 e0 ea ff ff       	call   f01026f2 <boot_map_region>

	ret[PDX(UVPT)] = PADDR(ret) | PTE_U | PTE_P;
f0103c12:	89 da                	mov    %ebx,%edx
f0103c14:	b8 6e 02 00 00       	mov    $0x26e,%eax
f0103c19:	e8 05 e9 ff ff       	call   f0102523 <_paddr.clone.0>
f0103c1e:	83 c8 05             	or     $0x5,%eax
f0103c21:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)

	return ret;
}
f0103c27:	89 d8                	mov    %ebx,%eax
f0103c29:	83 c4 18             	add    $0x18,%esp
f0103c2c:	5b                   	pop    %ebx
f0103c2d:	c3                   	ret    

f0103c2e <sys_get_num_free_page>:
// HINT: This is the system call implementation of get_num_free_page
int32_t
sys_get_num_free_page(void)
{
  return num_free_pages;
}
f0103c2e:	a1 cc 76 11 f0       	mov    0xf01176cc,%eax
f0103c33:	c3                   	ret    

f0103c34 <sys_get_num_used_page>:

// HINT: This is the system call implementation of get_num_used_page
int32_t
sys_get_num_used_page(void)
{
  return npages - num_free_pages; 
f0103c34:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f0103c39:	2b 05 cc 76 11 f0    	sub    0xf01176cc,%eax
}
f0103c3f:	c3                   	ret    

f0103c40 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0103c40:	56                   	push   %esi
f0103c41:	53                   	push   %ebx
f0103c42:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	if (panicstr)
f0103c45:	83 3d d4 76 11 f0 00 	cmpl   $0x0,0xf01176d4
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0103c4c:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	va_list ap;

	if (panicstr)
f0103c50:	75 37                	jne    f0103c89 <_panic+0x49>
		goto dead;
	panicstr = fmt;
f0103c52:	89 1d d4 76 11 f0    	mov    %ebx,0xf01176d4

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f0103c58:	fa                   	cli    
f0103c59:	fc                   	cld    

	va_start(ap, fmt);
f0103c5a:	8d 74 24 1c          	lea    0x1c(%esp),%esi
	printk("kernel panic at %s:%d: ", file, line);
f0103c5e:	51                   	push   %ecx
f0103c5f:	ff 74 24 18          	pushl  0x18(%esp)
f0103c63:	ff 74 24 18          	pushl  0x18(%esp)
f0103c67:	68 85 65 10 f0       	push   $0xf0106585
f0103c6c:	e8 5f e5 ff ff       	call   f01021d0 <printk>
	vprintk(fmt, ap);
f0103c71:	58                   	pop    %eax
f0103c72:	5a                   	pop    %edx
f0103c73:	56                   	push   %esi
f0103c74:	53                   	push   %ebx
f0103c75:	e8 2c e5 ff ff       	call   f01021a6 <vprintk>
	printk("\n");
f0103c7a:	c7 04 24 06 58 10 f0 	movl   $0xf0105806,(%esp)
f0103c81:	e8 4a e5 ff ff       	call   f01021d0 <printk>
	va_end(ap);
f0103c86:	83 c4 10             	add    $0x10,%esp
f0103c89:	eb fe                	jmp    f0103c89 <_panic+0x49>

f0103c8b <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0103c8b:	53                   	push   %ebx
f0103c8c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0103c8f:	8d 5c 24 1c          	lea    0x1c(%esp),%ebx
	printk("kernel warning at %s:%d: ", file, line);
f0103c93:	51                   	push   %ecx
f0103c94:	ff 74 24 18          	pushl  0x18(%esp)
f0103c98:	ff 74 24 18          	pushl  0x18(%esp)
f0103c9c:	68 9d 65 10 f0       	push   $0xf010659d
f0103ca1:	e8 2a e5 ff ff       	call   f01021d0 <printk>
	vprintk(fmt, ap);
f0103ca6:	58                   	pop    %eax
f0103ca7:	5a                   	pop    %edx
f0103ca8:	53                   	push   %ebx
f0103ca9:	ff 74 24 24          	pushl  0x24(%esp)
f0103cad:	e8 f4 e4 ff ff       	call   f01021a6 <vprintk>
	printk("\n");
f0103cb2:	c7 04 24 06 58 10 f0 	movl   $0xf0105806,(%esp)
f0103cb9:	e8 12 e5 ff ff       	call   f01021d0 <printk>
	va_end(ap);
}
f0103cbe:	83 c4 18             	add    $0x18,%esp
f0103cc1:	5b                   	pop    %ebx
f0103cc2:	c3                   	ret    
	...

f0103cc4 <mc146818_read>:
f0103cc4:	8b 44 24 04          	mov    0x4(%esp),%eax
f0103cc8:	ba 70 00 00 00       	mov    $0x70,%edx
f0103ccd:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103cce:	b2 71                	mov    $0x71,%dl
f0103cd0:	ec                   	in     (%dx),%al

unsigned
mc146818_read(unsigned reg)
{
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103cd1:	0f b6 c0             	movzbl %al,%eax
}
f0103cd4:	c3                   	ret    

f0103cd5 <mc146818_write>:
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103cd5:	ba 70 00 00 00       	mov    $0x70,%edx
f0103cda:	8b 44 24 04          	mov    0x4(%esp),%eax
f0103cde:	ee                   	out    %al,(%dx)
f0103cdf:	b2 71                	mov    $0x71,%dl
f0103ce1:	8b 44 24 08          	mov    0x8(%esp),%eax
f0103ce5:	ee                   	out    %al,(%dx)
void
mc146818_write(unsigned reg, unsigned datum)
{
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103ce6:	c3                   	ret    
	...

f0103ce8 <timer_handler>:
  outb(0x40, divisor >> 8);     /* Set high byte of divisor */
}

/* It is timer interrupt handler */
void timer_handler(struct Trapframe *tf)
{
f0103ce8:	83 ec 0c             	sub    $0xc,%esp
  extern void sched_yield();
  int i;

  jiffies++;
f0103ceb:	ff 05 28 4e 11 f0    	incl   0xf0114e28

  extern Task tasks[];

  extern Task *cur_task;

  if (cur_task != NULL)
f0103cf1:	83 3d 2c 4e 11 f0 00 	cmpl   $0x0,0xf0114e2c
f0103cf8:	74 5c                	je     f0103d56 <timer_handler+0x6e>
f0103cfa:	31 c0                	xor    %eax,%eax
   * Check if it is needed to wakeup sleep task
   * If remind_ticks <= 0, yield the task
   */
	for(i=0;i<NR_TASKS;i++)
	{
		switch(tasks[i].state){
f0103cfc:	8b 90 28 77 11 f0    	mov    -0xfee88d8(%eax),%edx
f0103d02:	83 fa 02             	cmp    $0x2,%edx
f0103d05:	74 2c                	je     f0103d33 <timer_handler+0x4b>
f0103d07:	83 fa 03             	cmp    $0x3,%edx
f0103d0a:	75 2d                	jne    f0103d39 <timer_handler+0x51>
			case TASK_SLEEP:
				tasks[i].remind_ticks--;
f0103d0c:	8b 90 24 77 11 f0    	mov    -0xfee88dc(%eax),%edx
f0103d12:	4a                   	dec    %edx
				if(tasks[i].remind_ticks <=0 )
f0103d13:	85 d2                	test   %edx,%edx
   */
	for(i=0;i<NR_TASKS;i++)
	{
		switch(tasks[i].state){
			case TASK_SLEEP:
				tasks[i].remind_ticks--;
f0103d15:	89 90 24 77 11 f0    	mov    %edx,-0xfee88dc(%eax)
				if(tasks[i].remind_ticks <=0 )
f0103d1b:	7f 1c                	jg     f0103d39 <timer_handler+0x51>
				{
					tasks[i].state = TASK_RUNNABLE;
f0103d1d:	c7 80 28 77 11 f0 01 	movl   $0x1,-0xfee88d8(%eax)
f0103d24:	00 00 00 
					tasks[i].remind_ticks = TIME_QUANT;
f0103d27:	c7 80 24 77 11 f0 64 	movl   $0x64,-0xfee88dc(%eax)
f0103d2e:	00 00 00 
f0103d31:	eb 06                	jmp    f0103d39 <timer_handler+0x51>
				}
				break;
			case TASK_RUNNING:
				tasks[i].remind_ticks--;
f0103d33:	ff 88 24 77 11 f0    	decl   -0xfee88dc(%eax)
				break;
f0103d39:	83 c0 58             	add    $0x58,%eax
  {
  /* TODO: Lab 5
   * Check if it is needed to wakeup sleep task
   * If remind_ticks <= 0, yield the task
   */
	for(i=0;i<NR_TASKS;i++)
f0103d3c:	3d 70 03 00 00       	cmp    $0x370,%eax
f0103d41:	75 b9                	jne    f0103cfc <timer_handler+0x14>
				break;
		}
	}

	//Check cur_task->remind_ticks, if remind_ticks <= 0 then yield the task (sched_yield_()) in sched.c
	if(cur_task->remind_ticks <= 0)
f0103d43:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0103d48:	83 78 4c 00          	cmpl   $0x0,0x4c(%eax)
f0103d4c:	7f 08                	jg     f0103d56 <timer_handler+0x6e>
	{
		sched_yield();
	}
  }
}
f0103d4e:	83 c4 0c             	add    $0xc,%esp
	}

	//Check cur_task->remind_ticks, if remind_ticks <= 0 then yield the task (sched_yield_()) in sched.c
	if(cur_task->remind_ticks <= 0)
	{
		sched_yield();
f0103d51:	e9 c2 05 00 00       	jmp    f0104318 <sched_yield>
	}
  }
}
f0103d56:	83 c4 0c             	add    $0xc,%esp
f0103d59:	c3                   	ret    

f0103d5a <set_timer>:

static unsigned long jiffies = 0;

void set_timer(int hz)
{
  int divisor = 1193180 / hz;       /* Calculate our divisor */
f0103d5a:	b9 dc 34 12 00       	mov    $0x1234dc,%ecx
f0103d5f:	89 c8                	mov    %ecx,%eax
f0103d61:	99                   	cltd   
f0103d62:	f7 7c 24 04          	idivl  0x4(%esp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103d66:	ba 43 00 00 00       	mov    $0x43,%edx
f0103d6b:	89 c1                	mov    %eax,%ecx
f0103d6d:	b0 36                	mov    $0x36,%al
f0103d6f:	ee                   	out    %al,(%dx)
f0103d70:	b2 40                	mov    $0x40,%dl
f0103d72:	88 c8                	mov    %cl,%al
f0103d74:	ee                   	out    %al,(%dx)
  outb(0x43, 0x36);             /* Set our command byte 0x36 */
  outb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
  outb(0x40, divisor >> 8);     /* Set high byte of divisor */
f0103d75:	89 c8                	mov    %ecx,%eax
f0103d77:	c1 f8 08             	sar    $0x8,%eax
f0103d7a:	ee                   	out    %al,(%dx)
}
f0103d7b:	c3                   	ret    

f0103d7c <sys_get_ticks>:
}

unsigned long sys_get_ticks()
{
  return jiffies;
}
f0103d7c:	a1 28 4e 11 f0       	mov    0xf0114e28,%eax
f0103d81:	c3                   	ret    

f0103d82 <timer_init>:
void timer_init()
{
f0103d82:	83 ec 0c             	sub    $0xc,%esp
  set_timer(TIME_HZ);
f0103d85:	6a 64                	push   $0x64
f0103d87:	e8 ce ff ff ff       	call   f0103d5a <set_timer>

  /* Enable interrupt */
  irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_TIMER));
f0103d8c:	50                   	push   %eax
f0103d8d:	50                   	push   %eax
f0103d8e:	0f b7 05 3c 70 10 f0 	movzwl 0xf010703c,%eax
f0103d95:	25 fe ff 00 00       	and    $0xfffe,%eax
f0103d9a:	50                   	push   %eax
f0103d9b:	e8 78 db ff ff       	call   f0101918 <irq_setmask_8259A>

  /* Register trap handler */
  extern void TIM_ISR();
  register_handler( IRQ_OFFSET + IRQ_TIMER, &timer_handler, &TIM_ISR, 0, 0);
f0103da0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103da7:	6a 00                	push   $0x0
f0103da9:	68 3c 21 10 f0       	push   $0xf010213c
f0103dae:	68 e8 3c 10 f0       	push   $0xf0103ce8
f0103db3:	6a 20                	push   $0x20
f0103db5:	e8 8b e1 ff ff       	call   f0101f45 <register_handler>
}
f0103dba:	83 c4 2c             	add    $0x2c,%esp
f0103dbd:	c3                   	ret    
	...

f0103dc0 <task_create>:
 *
 * 6. Return the pid of the newly created task.
 *
 */
int task_create()
{
f0103dc0:	57                   	push   %edi
  if (!(ts->pgdir = setupkvm()))//free ts->pgdir
    panic("Not enough memory for per process page directory!\n");

	//printk("1. ts->pgdir = 0x%x\n",PTE_ADDR(ts->pgdir));

	if(i >= NR_TASKS) return -1;
f0103dc1:	b8 28 77 11 f0       	mov    $0xf0117728,%eax
 *
 * 6. Return the pid of the newly created task.
 *
 */
int task_create()
{
f0103dc6:	56                   	push   %esi
	/* Find a free task structure */
	int i = 0;
	Task *ts = NULL;
	
	for(i=0;i<NR_TASKS;i++)
f0103dc7:	31 f6                	xor    %esi,%esi
 *
 * 6. Return the pid of the newly created task.
 *
 */
int task_create()
{
f0103dc9:	53                   	push   %ebx
	int i = 0;
	Task *ts = NULL;
	
	for(i=0;i<NR_TASKS;i++)
	{
		if(tasks[i].state == TASK_FREE /*|| tasks[i].state == TASK_STOP */)
f0103dca:	83 38 00             	cmpl   $0x0,(%eax)
f0103dcd:	75 0b                	jne    f0103dda <task_create+0x1a>
		{
			ts = &(tasks[i]);
f0103dcf:	6b de 58             	imul   $0x58,%esi,%ebx
f0103dd2:	81 c3 d8 76 11 f0    	add    $0xf01176d8,%ebx
			break;
f0103dd8:	eb 0b                	jmp    f0103de5 <task_create+0x25>
{
	/* Find a free task structure */
	int i = 0;
	Task *ts = NULL;
	
	for(i=0;i<NR_TASKS;i++)
f0103dda:	46                   	inc    %esi
f0103ddb:	83 c0 58             	add    $0x58,%eax
f0103dde:	83 fe 0a             	cmp    $0xa,%esi
f0103de1:	75 e7                	jne    f0103dca <task_create+0xa>
 */
int task_create()
{
	/* Find a free task structure */
	int i = 0;
	Task *ts = NULL;
f0103de3:	31 db                	xor    %ebx,%ebx
	}

	

  /* Setup Page Directory and pages for kernel*/
  if (!(ts->pgdir = setupkvm()))//free ts->pgdir
f0103de5:	e8 6c fd ff ff       	call   f0103b56 <setupkvm>
f0103dea:	85 c0                	test   %eax,%eax
f0103dec:	89 43 54             	mov    %eax,0x54(%ebx)
f0103def:	75 0a                	jne    f0103dfb <task_create+0x3b>
    panic("Not enough memory for per process page directory!\n");
f0103df1:	51                   	push   %ecx
f0103df2:	68 b7 65 10 f0       	push   $0xf01065b7
f0103df7:	6a 7b                	push   $0x7b
f0103df9:	eb 2a                	jmp    f0103e25 <task_create+0x65>

	//printk("1. ts->pgdir = 0x%x\n",PTE_ADDR(ts->pgdir));

	if(i >= NR_TASKS) return -1;
f0103dfb:	83 fe 09             	cmp    $0x9,%esi
f0103dfe:	0f 8f be 00 00 00    	jg     f0103ec2 <task_create+0x102>
f0103e04:	bf 00 40 bf ee       	mov    $0xeebf4000,%edi
  /* Setup User Stack */
	uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
	uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

	for(; us_start < us_end; us_start+=PGSIZE){
		struct PageInfo *pp = page_alloc(1);//get pp
f0103e09:	83 ec 0c             	sub    $0xc,%esp
f0103e0c:	6a 01                	push   $0x1
f0103e0e:	e8 b3 e7 ff ff       	call   f01025c6 <page_alloc>

		//printk("2. pp = 0x%x\n",page2pa(pp));
		if(!pp){
f0103e13:	83 c4 10             	add    $0x10,%esp
f0103e16:	85 c0                	test   %eax,%eax
f0103e18:	75 15                	jne    f0103e2f <task_create+0x6f>
			panic("page_alloc(0) failed!");
f0103e1a:	52                   	push   %edx
f0103e1b:	68 f8 65 10 f0       	push   $0xf01065f8
f0103e20:	68 8a 00 00 00       	push   $0x8a
f0103e25:	68 ea 65 10 f0       	push   $0xf01065ea
f0103e2a:	e8 11 fe ff ff       	call   f0103c40 <_panic>
		}
		else{
			if(page_insert(ts->pgdir, pp, (void*) us_start, PTE_U|PTE_W) == -E_NO_MEM)// pp
f0103e2f:	6a 06                	push   $0x6
f0103e31:	57                   	push   %edi
f0103e32:	50                   	push   %eax
f0103e33:	ff 73 54             	pushl  0x54(%ebx)
f0103e36:	e8 a0 e9 ff ff       	call   f01027db <page_insert>
f0103e3b:	83 c4 10             	add    $0x10,%esp
f0103e3e:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0103e41:	75 11                	jne    f0103e54 <task_create+0x94>
				panic("User stack page insert failed at %p", USTACKTOP - USR_STACK_SIZE);
f0103e43:	68 00 40 bf ee       	push   $0xeebf4000
f0103e48:	68 0e 66 10 f0       	push   $0xf010660e
f0103e4d:	68 8e 00 00 00       	push   $0x8e
f0103e52:	eb d1                	jmp    f0103e25 <task_create+0x65>
  
  /* Setup User Stack */
	uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
	uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

	for(; us_start < us_end; us_start+=PGSIZE){
f0103e54:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0103e5a:	81 ff 00 e0 bf ee    	cmp    $0xeebfe000,%edi
f0103e60:	75 a7                	jne    f0103e09 <task_create+0x49>
	}
	//printk("Setup USer Stack Done!\n");		

	/* Setup Trapframe */
	
	memset( &(ts->tf), 0, sizeof(ts->tf));
f0103e62:	50                   	push   %eax
f0103e63:	6a 44                	push   $0x44
f0103e65:	6a 00                	push   $0x0
f0103e67:	8d 43 08             	lea    0x8(%ebx),%eax
f0103e6a:	50                   	push   %eax
f0103e6b:	e8 5f c3 ff ff       	call   f01001cf <memset>
	
	ts->task_id = i;
	ts->state = TASK_RUNNABLE;

	//ts->parent_id = cur_task->task_id;
	if(i==0) ts->parent_id = 0;
f0103e70:	83 c4 10             	add    $0x10,%esp
f0103e73:	85 f6                	test   %esi,%esi

	/* Setup Trapframe */
	
	memset( &(ts->tf), 0, sizeof(ts->tf));

	ts->tf.tf_cs = GD_UT | 0x03;
f0103e75:	66 c7 43 3c 1b 00    	movw   $0x1b,0x3c(%ebx)
	ts->tf.tf_ds = GD_UD | 0x03;
f0103e7b:	66 c7 43 2c 23 00    	movw   $0x23,0x2c(%ebx)
	ts->tf.tf_es = GD_UD | 0x03;
f0103e81:	66 c7 43 28 23 00    	movw   $0x23,0x28(%ebx)
	ts->tf.tf_ss = GD_UD | 0x03;
f0103e87:	66 c7 43 48 23 00    	movw   $0x23,0x48(%ebx)
	ts->tf.tf_esp = USTACKTOP-PGSIZE;
f0103e8d:	c7 43 44 00 d0 bf ee 	movl   $0xeebfd000,0x44(%ebx)
	
	/* Setup task structure (task_id and parent_id) */
	
	ts->task_id = i;
f0103e94:	89 33                	mov    %esi,(%ebx)
	ts->state = TASK_RUNNABLE;
f0103e96:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)

	//ts->parent_id = cur_task->task_id;
	if(i==0) ts->parent_id = 0;
f0103e9d:	75 09                	jne    f0103ea8 <task_create+0xe8>
f0103e9f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
f0103ea6:	eb 11                	jmp    f0103eb9 <task_create+0xf9>
	else ts->parent_id = (cur_task == NULL)?0:cur_task->task_id;
f0103ea8:	8b 15 2c 4e 11 f0    	mov    0xf0114e2c,%edx
f0103eae:	31 c0                	xor    %eax,%eax
f0103eb0:	85 d2                	test   %edx,%edx
f0103eb2:	74 02                	je     f0103eb6 <task_create+0xf6>
f0103eb4:	8b 02                	mov    (%edx),%eax
f0103eb6:	89 43 04             	mov    %eax,0x4(%ebx)

	ts->remind_ticks = TIME_QUANT;
f0103eb9:	c7 43 4c 64 00 00 00 	movl   $0x64,0x4c(%ebx)
	
	return i;
f0103ec0:	eb 03                	jmp    f0103ec5 <task_create+0x105>
  if (!(ts->pgdir = setupkvm()))//free ts->pgdir
    panic("Not enough memory for per process page directory!\n");

	//printk("1. ts->pgdir = 0x%x\n",PTE_ADDR(ts->pgdir));

	if(i >= NR_TASKS) return -1;
f0103ec2:	83 ce ff             	or     $0xffffffff,%esi
	else ts->parent_id = (cur_task == NULL)?0:cur_task->task_id;

	ts->remind_ticks = TIME_QUANT;
	
	return i;
}
f0103ec5:	89 f0                	mov    %esi,%eax
f0103ec7:	5b                   	pop    %ebx
f0103ec8:	5e                   	pop    %esi
f0103ec9:	5f                   	pop    %edi
f0103eca:	c3                   	ret    

f0103ecb <sys_kill>:
	//tasks[pid].pgdir = 0;
	//page_decref(pa2page(pa));
}

void sys_kill(int pid)
{
f0103ecb:	57                   	push   %edi
f0103ecc:	56                   	push   %esi
f0103ecd:	53                   	push   %ebx
f0103ece:	8b 74 24 10          	mov    0x10(%esp),%esi
	//printk("not yet sys_kill, %d\n",pid);
	if (pid > 0 && pid < NR_TASKS)
f0103ed2:	8d 46 ff             	lea    -0x1(%esi),%eax
f0103ed5:	83 f8 08             	cmp    $0x8,%eax
f0103ed8:	77 75                	ja     f0103f4f <sys_kill+0x84>
	//page_remove(pde_t *pgdir, void *va)
	//page2kva(struct PageInfo *pp)
	//ptable_remove(pde_t *pgdir)
	//pgdir_remove(pde_t *pgdir)

	lcr3(PADDR(kern_pgdir));
f0103eda:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
	/* TODO: Lab 5
   * Remember to change the state of tasks
   * Free the memory
   * and invoke the scheduler for yield
   */
		tasks[pid].state = TASK_STOP;
f0103edf:	6b f6 58             	imul   $0x58,%esi,%esi
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103ee2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ee7:	c7 86 28 77 11 f0 04 	movl   $0x4,-0xfee88d8(%esi)
f0103eee:	00 00 00 
f0103ef1:	77 15                	ja     f0103f08 <sys_kill+0x3d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103ef3:	50                   	push   %eax
f0103ef4:	68 c2 54 10 f0       	push   $0xf01054c2
f0103ef9:	68 c4 00 00 00       	push   $0xc4
f0103efe:	68 ea 65 10 f0       	push   $0xf01065ea
f0103f03:	e8 38 fd ff ff       	call   f0103c40 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103f08:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103f0d:	0f 22 d8             	mov    %eax,%cr3
	//pgdir_remove(pde_t *pgdir)

	lcr3(PADDR(kern_pgdir));
	
	//remove pages of user stack
	uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
f0103f10:	bb 00 40 bf ee       	mov    $0xeebf4000,%ebx
	uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

	for(; us_start < us_end; us_start+=PGSIZE){
		//struct PageInfo *pp_child = page_lookup(tasks[pid].pgdir, us_start, NULL);
		page_remove(tasks[pid].pgdir, us_start);
f0103f15:	81 c6 dc 76 11 f0    	add    $0xf01176dc,%esi
f0103f1b:	57                   	push   %edi
f0103f1c:	57                   	push   %edi
f0103f1d:	53                   	push   %ebx
	
	//remove pages of user stack
	uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
	uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

	for(; us_start < us_end; us_start+=PGSIZE){
f0103f1e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		//struct PageInfo *pp_child = page_lookup(tasks[pid].pgdir, us_start, NULL);
		page_remove(tasks[pid].pgdir, us_start);
f0103f24:	ff 76 50             	pushl  0x50(%esi)
f0103f27:	8d 7e 50             	lea    0x50(%esi),%edi
f0103f2a:	e8 64 e8 ff ff       	call   f0102793 <page_remove>
	
	//remove pages of user stack
	uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
	uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

	for(; us_start < us_end; us_start+=PGSIZE){
f0103f2f:	83 c4 10             	add    $0x10,%esp
f0103f32:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
f0103f38:	75 e1                	jne    f0103f1b <sys_kill+0x50>
		//struct PageInfo *pp_child = page_lookup(tasks[pid].pgdir, us_start, NULL);
		page_remove(tasks[pid].pgdir, us_start);
	}

	//remove pages of page table
	ptable_remove(tasks[pid].pgdir);
f0103f3a:	83 ec 0c             	sub    $0xc,%esp
f0103f3d:	ff 37                	pushl  (%edi)
f0103f3f:	e8 27 fb ff ff       	call   f0103a6b <ptable_remove>
   * and invoke the scheduler for yield
   */
		tasks[pid].state = TASK_STOP;
		task_free(pid);
		//printk("down sys_kill\n");
		sched_yield();
f0103f44:	83 c4 10             	add    $0x10,%esp
		
	}
}
f0103f47:	5b                   	pop    %ebx
f0103f48:	5e                   	pop    %esi
f0103f49:	5f                   	pop    %edi
   * and invoke the scheduler for yield
   */
		tasks[pid].state = TASK_STOP;
		task_free(pid);
		//printk("down sys_kill\n");
		sched_yield();
f0103f4a:	e9 c9 03 00 00       	jmp    f0104318 <sched_yield>
		
	}
}
f0103f4f:	5b                   	pop    %ebx
f0103f50:	5e                   	pop    %esi
f0103f51:	5f                   	pop    %edi
f0103f52:	c3                   	ret    

f0103f53 <sys_fork>:
 *
 * HINT: You should understand how system call return
 * it's return value.
 */
int sys_fork()
{
f0103f53:	55                   	push   %ebp
f0103f54:	57                   	push   %edi
f0103f55:	56                   	push   %esi
f0103f56:	53                   	push   %ebx
f0103f57:	83 ec 1c             	sub    $0x1c,%esp
  	/* pid for newly created process */
  	int pid = -1;
	int offset = 0;
	int i = 0;

	pid = task_create();
f0103f5a:	e8 61 fe ff ff       	call   f0103dc0 <task_create>
	if(pid < 0) return -1;
f0103f5f:	85 c0                	test   %eax,%eax
  	/* pid for newly created process */
  	int pid = -1;
	int offset = 0;
	int i = 0;

	pid = task_create();
f0103f61:	89 44 24 0c          	mov    %eax,0xc(%esp)
	if(pid < 0) return -1;
f0103f65:	79 08                	jns    f0103f6f <sys_fork+0x1c>
f0103f67:	83 c8 ff             	or     $0xffffffff,%eax
f0103f6a:	e9 03 01 00 00       	jmp    f0104072 <sys_fork+0x11f>
	if ((uint32_t)cur_task != NULL)
f0103f6f:	83 3d 2c 4e 11 f0 00 	cmpl   $0x0,0xf0114e2c
f0103f76:	0f 84 f6 00 00 00    	je     f0104072 <sys_fork+0x11f>
	{
    		/* Step 4: All user program use the same code for now */
    		setupvm(tasks[pid].pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f0103f7c:	53                   	push   %ebx
f0103f7d:	ff 35 34 7c 11 f0    	pushl  0xf0117c34
f0103f83:	68 00 00 10 f0       	push   $0xf0100000
f0103f88:	6b 6c 24 18 58       	imul   $0x58,0x18(%esp),%ebp
f0103f8d:	8d 9d dc 76 11 f0    	lea    -0xfee8924(%ebp),%ebx
f0103f93:	ff 73 50             	pushl  0x50(%ebx)
    		setupvm(tasks[pid].pgdir, (uint32_t)UDATA_start, UDATA_SZ);
    		setupvm(tasks[pid].pgdir, (uint32_t)UBSS_start, UBSS_SZ);
    		setupvm(tasks[pid].pgdir, (uint32_t)URODATA_start, URODATA_SZ);

		//2. copy the trapframe
		tasks[pid].tf = cur_task->tf;
f0103f96:	8d bd e0 76 11 f0    	lea    -0xfee8920(%ebp),%edi
	pid = task_create();
	if(pid < 0) return -1;
	if ((uint32_t)cur_task != NULL)
	{
    		/* Step 4: All user program use the same code for now */
    		setupvm(tasks[pid].pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f0103f9c:	e8 41 fb ff ff       	call   f0103ae2 <setupvm>
    		setupvm(tasks[pid].pgdir, (uint32_t)UDATA_start, UDATA_SZ);
f0103fa1:	83 c4 0c             	add    $0xc,%esp
f0103fa4:	ff 35 30 7c 11 f0    	pushl  0xf0117c30
f0103faa:	68 00 70 10 f0       	push   $0xf0107000
f0103faf:	ff 73 50             	pushl  0x50(%ebx)
f0103fb2:	e8 2b fb ff ff       	call   f0103ae2 <setupvm>
    		setupvm(tasks[pid].pgdir, (uint32_t)UBSS_start, UBSS_SZ);
f0103fb7:	83 c4 0c             	add    $0xc,%esp
f0103fba:	ff 35 48 7a 11 f0    	pushl  0xf0117a48
f0103fc0:	68 00 b0 10 f0       	push   $0xf010b000
f0103fc5:	ff 73 50             	pushl  0x50(%ebx)
f0103fc8:	e8 15 fb ff ff       	call   f0103ae2 <setupvm>
    		setupvm(tasks[pid].pgdir, (uint32_t)URODATA_start, URODATA_SZ);
f0103fcd:	83 c4 0c             	add    $0xc,%esp
f0103fd0:	ff 35 4c 7a 11 f0    	pushl  0xf0117a4c
f0103fd6:	68 00 50 10 f0       	push   $0xf0105000
f0103fdb:	ff 73 50             	pushl  0x50(%ebx)
f0103fde:	e8 ff fa ff ff       	call   f0103ae2 <setupvm>

		//2. copy the trapframe
		tasks[pid].tf = cur_task->tf;
f0103fe3:	8b 35 2c 4e 11 f0    	mov    0xf0114e2c,%esi
f0103fe9:	b9 11 00 00 00       	mov    $0x11,%ecx
f0103fee:	83 c4 10             	add    $0x10,%esp
f0103ff1:	83 c6 08             	add    $0x8,%esi
f0103ff4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			memcpy(page2kva(pp_child), USTACKTOP-USR_STACK_SIZE+i*PGSIZE, PGSIZE);
			//printk("after\n");
		}
		*/

		uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
f0103ff6:	be 00 40 bf ee       	mov    $0xeebf4000,%esi
		uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

		for(; us_start < us_end; us_start+=PGSIZE){
			struct PageInfo *pp_child = page_lookup(tasks[pid].pgdir, us_start, NULL);
f0103ffb:	51                   	push   %ecx
f0103ffc:	6a 00                	push   $0x0
f0103ffe:	56                   	push   %esi
f0103fff:	ff 73 50             	pushl  0x50(%ebx)
f0104002:	e8 51 e7 ff ff       	call   f0102758 <page_lookup>
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104007:	83 c4 10             	add    $0x10,%esp
}

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010400a:	2b 05 d0 76 11 f0    	sub    0xf01176d0,%eax
f0104010:	c1 f8 03             	sar    $0x3,%eax
f0104013:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104016:	89 c2                	mov    %eax,%edx
f0104018:	c1 ea 0c             	shr    $0xc,%edx
f010401b:	3b 15 c4 76 11 f0    	cmp    0xf01176c4,%edx
f0104021:	72 12                	jb     f0104035 <sys_fork+0xe2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0104023:	50                   	push   %eax
f0104024:	68 9c 5a 10 f0       	push   $0xf0105a9c
f0104029:	6a 55                	push   $0x55
f010402b:	68 bf 5a 10 f0       	push   $0xf0105abf
f0104030:	e8 0b fc ff ff       	call   f0103c40 <_panic>
			//page2kva(pp_parent) = USTACKTOP - USR_STACK_SIZE + i*PGSIZE;
			
			//printk("before\n");
			memcpy(page2kva(pp_child), us_start, PGSIZE);
f0104035:	52                   	push   %edx
	return (void *)(pa + KERNBASE);
f0104036:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010403b:	68 00 10 00 00       	push   $0x1000
f0104040:	56                   	push   %esi
		*/

		uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
		uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

		for(; us_start < us_end; us_start+=PGSIZE){
f0104041:	81 c6 00 10 00 00    	add    $0x1000,%esi
			struct PageInfo *pp_child = page_lookup(tasks[pid].pgdir, us_start, NULL);
			//page2kva(pp_parent) = USTACKTOP - USR_STACK_SIZE + i*PGSIZE;
			
			//printk("before\n");
			memcpy(page2kva(pp_child), us_start, PGSIZE);
f0104047:	50                   	push   %eax
f0104048:	e8 5c c2 ff ff       	call   f01002a9 <memcpy>
		*/

		uintptr_t us_start = USTACKTOP - USR_STACK_SIZE;//(uintptr_t) ROUNDDOWN(USTACKTOP - USR_STACK_SIZE, PGSIZE);
		uintptr_t us_end = USTACKTOP;//(uintptr_t) ROUNDDOWN(USTACKTOP, PGSIZE);

		for(; us_start < us_end; us_start+=PGSIZE){
f010404d:	83 c4 10             	add    $0x10,%esp
f0104050:	81 fe 00 e0 bf ee    	cmp    $0xeebfe000,%esi
f0104056:	75 a3                	jne    f0103ffb <sys_fork+0xa8>
			//printk("after\n");
		}

		//5.
		tasks[pid].tf.tf_regs.reg_eax = 0;
		tasks[pid].parent_id = cur_task->task_id;
f0104058:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
			memcpy(page2kva(pp_child), us_start, PGSIZE);
			//printk("after\n");
		}

		//5.
		tasks[pid].tf.tf_regs.reg_eax = 0;
f010405d:	c7 85 fc 76 11 f0 00 	movl   $0x0,-0xfee8904(%ebp)
f0104064:	00 00 00 
		tasks[pid].parent_id = cur_task->task_id;
f0104067:	8b 10                	mov    (%eax),%edx
f0104069:	89 13                	mov    %edx,(%ebx)
		cur_task->tf.tf_regs.reg_eax = pid;
f010406b:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010406f:	89 50 24             	mov    %edx,0x24(%eax)
			
		//return 0;
	}
	//return 0;
}
f0104072:	83 c4 1c             	add    $0x1c,%esp
f0104075:	5b                   	pop    %ebx
f0104076:	5e                   	pop    %esi
f0104077:	5f                   	pop    %edi
f0104078:	5d                   	pop    %ebp
f0104079:	c3                   	ret    

f010407a <task_init>:
 */
void task_init()
{
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f010407a:	b8 f8 17 10 f0       	mov    $0xf01017f8,%eax
/* TODO: Lab5
 * We've done the initialization for you,
 * please make sure you understand the code.
 */
void task_init()
{
f010407f:	53                   	push   %ebx
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f0104080:	2d 00 00 10 f0       	sub    $0xf0100000,%eax
/* TODO: Lab5
 * We've done the initialization for you,
 * please make sure you understand the code.
 */
void task_init()
{
f0104085:	83 ec 08             	sub    $0x8,%esp
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);
f0104088:	bb d8 76 11 f0       	mov    $0xf01176d8,%ebx
 */
void task_init()
{
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f010408d:	a3 34 7c 11 f0       	mov    %eax,0xf0117c34
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
f0104092:	b8 3c 70 10 f0       	mov    $0xf010703c,%eax
f0104097:	2d 00 70 10 f0       	sub    $0xf0107000,%eax
f010409c:	a3 30 7c 11 f0       	mov    %eax,0xf0117c30
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
f01040a1:	b8 38 7c 11 f0       	mov    $0xf0117c38,%eax
f01040a6:	2d 00 b0 10 f0       	sub    $0xf010b000,%eax
f01040ab:	a3 48 7a 11 f0       	mov    %eax,0xf0117a48
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);
f01040b0:	b8 88 51 10 f0       	mov    $0xf0105188,%eax
f01040b5:	2d 00 50 10 f0       	sub    $0xf0105000,%eax
f01040ba:	a3 4c 7a 11 f0       	mov    %eax,0xf0117a4c

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
	{
		memset(&(tasks[i]), 0, sizeof(Task));
f01040bf:	52                   	push   %edx
f01040c0:	6a 58                	push   $0x58
f01040c2:	6a 00                	push   $0x0
f01040c4:	53                   	push   %ebx
f01040c5:	e8 05 c1 ff ff       	call   f01001cf <memset>
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
f01040ca:	83 c4 10             	add    $0x10,%esp
	{
		memset(&(tasks[i]), 0, sizeof(Task));
		tasks[i].state = TASK_FREE;
f01040cd:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
f01040d4:	83 c3 58             	add    $0x58,%ebx
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
f01040d7:	81 fb 48 7a 11 f0    	cmp    $0xf0117a48,%ebx
f01040dd:	75 e0                	jne    f01040bf <task_init+0x45>
		tasks[i].state = TASK_FREE;

	}
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	memset(&(tss), 0, sizeof(tss));
f01040df:	50                   	push   %eax
f01040e0:	6a 68                	push   $0x68
f01040e2:	6a 00                	push   $0x0
f01040e4:	68 30 4e 11 f0       	push   $0xf0114e30
f01040e9:	e8 e1 c0 ff ff       	call   f01001cf <memset>
	// fs and gs stay in user data segment
	tss.ts_fs = GD_UD | 0x03;
	tss.ts_gs = GD_UD | 0x03;

	/* Setup TSS in GDT */
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
f01040ee:	b8 30 4e 11 f0       	mov    $0xf0114e30,%eax
f01040f3:	89 c2                	mov    %eax,%edx
f01040f5:	c1 ea 10             	shr    $0x10,%edx
f01040f8:	66 a3 2a a0 10 f0    	mov    %ax,0xf010a02a
f01040fe:	c1 e8 18             	shr    $0x18,%eax
f0104101:	88 15 2c a0 10 f0    	mov    %dl,0xf010a02c

	}
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	memset(&(tss), 0, sizeof(tss));
	tss.ts_esp0 = (uint32_t)bootstack + KSTKSIZE;
f0104107:	c7 05 34 4e 11 f0 00 	movl   $0xf0114000,0xf0114e34
f010410e:	40 11 f0 
	tss.ts_ss0 = GD_KD;
f0104111:	66 c7 05 38 4e 11 f0 	movw   $0x10,0xf0114e38
f0104118:	10 00 

	// fs and gs stay in user data segment
	tss.ts_fs = GD_UD | 0x03;
f010411a:	66 c7 05 88 4e 11 f0 	movw   $0x23,0xf0114e88
f0104121:	23 00 
	tss.ts_gs = GD_UD | 0x03;
f0104123:	66 c7 05 8c 4e 11 f0 	movw   $0x23,0xf0114e8c
f010412a:	23 00 

	/* Setup TSS in GDT */
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
f010412c:	66 c7 05 28 a0 10 f0 	movw   $0x68,0xf010a028
f0104133:	68 00 
f0104135:	c6 05 2e a0 10 f0 40 	movb   $0x40,0xf010a02e
f010413c:	a2 2f a0 10 f0       	mov    %al,0xf010a02f
	gdt[GD_TSS0 >> 3].sd_s = 0;
f0104141:	c6 05 2d a0 10 f0 89 	movb   $0x89,0xf010a02d

	/* Setup first task */
	i = task_create();//!!!!!!!!!!!!!!!!!!!!!!!! get new task !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
f0104148:	e8 73 fc ff ff       	call   f0103dc0 <task_create>
	cur_task = &(tasks[i]);

  /* For user program */
  setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f010414d:	83 c4 0c             	add    $0xc,%esp
f0104150:	ff 35 34 7c 11 f0    	pushl  0xf0117c34
f0104156:	68 00 00 10 f0       	push   $0xf0100000
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	/* Setup first task */
	i = task_create();//!!!!!!!!!!!!!!!!!!!!!!!! get new task !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	cur_task = &(tasks[i]);
f010415b:	6b c0 58             	imul   $0x58,%eax,%eax

  /* For user program */
  setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f010415e:	ff b0 2c 77 11 f0    	pushl  -0xfee88d4(%eax)
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	/* Setup first task */
	i = task_create();//!!!!!!!!!!!!!!!!!!!!!!!! get new task !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	cur_task = &(tasks[i]);
f0104164:	8d 90 d8 76 11 f0    	lea    -0xfee8928(%eax),%edx
f010416a:	89 15 2c 4e 11 f0    	mov    %edx,0xf0114e2c

  /* For user program */
  setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f0104170:	e8 6d f9 ff ff       	call   f0103ae2 <setupvm>
  setupvm(cur_task->pgdir, (uint32_t)UDATA_start, UDATA_SZ);
f0104175:	83 c4 0c             	add    $0xc,%esp
f0104178:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f010417d:	ff 35 30 7c 11 f0    	pushl  0xf0117c30
f0104183:	68 00 70 10 f0       	push   $0xf0107000
f0104188:	ff 70 54             	pushl  0x54(%eax)
f010418b:	e8 52 f9 ff ff       	call   f0103ae2 <setupvm>
  setupvm(cur_task->pgdir, (uint32_t)UBSS_start, UBSS_SZ);
f0104190:	83 c4 0c             	add    $0xc,%esp
f0104193:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0104198:	ff 35 48 7a 11 f0    	pushl  0xf0117a48
f010419e:	68 00 b0 10 f0       	push   $0xf010b000
f01041a3:	ff 70 54             	pushl  0x54(%eax)
f01041a6:	e8 37 f9 ff ff       	call   f0103ae2 <setupvm>
  setupvm(cur_task->pgdir, (uint32_t)URODATA_start, URODATA_SZ);
f01041ab:	83 c4 0c             	add    $0xc,%esp
f01041ae:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f01041b3:	ff 35 4c 7a 11 f0    	pushl  0xf0117a4c
f01041b9:	68 00 50 10 f0       	push   $0xf0105000
f01041be:	ff 70 54             	pushl  0x54(%eax)
f01041c1:	e8 1c f9 ff ff       	call   f0103ae2 <setupvm>
  cur_task->tf.tf_eip = (uint32_t)user_entry;
f01041c6:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f01041cb:	ba 30 a0 10 f0       	mov    $0xf010a030,%edx
f01041d0:	c7 40 38 b8 14 10 f0 	movl   $0xf01014b8,0x38(%eax)
f01041d7:	0f 01 12             	lgdtl  (%edx)
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f01041da:	31 d2                	xor    %edx,%edx
f01041dc:	0f 00 d2             	lldt   %dx
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01041df:	b2 28                	mov    $0x28,%dl
f01041e1:	0f 00 da             	ltr    %dx
	lldt(0);

	// Load the TSS selector 
	ltr(GD_TSS0);

	cur_task->state = TASK_RUNNING;
f01041e4:	c7 40 50 02 00 00 00 	movl   $0x2,0x50(%eax)
	printk("end task_init()\n");
f01041eb:	c7 04 24 32 66 10 f0 	movl   $0xf0106632,(%esp)
f01041f2:	e8 d9 df ff ff       	call   f01021d0 <printk>
}
f01041f7:	83 c4 18             	add    $0x18,%esp
f01041fa:	5b                   	pop    %ebx
f01041fb:	c3                   	ret    

f01041fc <do_puts>:
#include <kernel/syscall.h>
#include <kernel/trap.h>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
f01041fc:	57                   	push   %edi
f01041fd:	56                   	push   %esi
f01041fe:	53                   	push   %ebx
	uint32_t i;
	for (i = 0; i < len; i++)
f01041ff:	31 db                	xor    %ebx,%ebx
#include <kernel/syscall.h>
#include <kernel/trap.h>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
f0104201:	8b 7c 24 10          	mov    0x10(%esp),%edi
f0104205:	8b 74 24 14          	mov    0x14(%esp),%esi
	uint32_t i;
	for (i = 0; i < len; i++)
f0104209:	eb 11                	jmp    f010421c <do_puts+0x20>
	{
		k_putch(str[i]);
f010420b:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
f010420f:	83 ec 0c             	sub    $0xc,%esp
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
	uint32_t i;
	for (i = 0; i < len; i++)
f0104212:	43                   	inc    %ebx
	{
		k_putch(str[i]);
f0104213:	50                   	push   %eax
f0104214:	e8 06 da ff ff       	call   f0101c1f <k_putch>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
	uint32_t i;
	for (i = 0; i < len; i++)
f0104219:	83 c4 10             	add    $0x10,%esp
f010421c:	39 f3                	cmp    %esi,%ebx
f010421e:	72 eb                	jb     f010420b <do_puts+0xf>
	{
		k_putch(str[i]);
	}
}
f0104220:	5b                   	pop    %ebx
f0104221:	5e                   	pop    %esi
f0104222:	5f                   	pop    %edi
f0104223:	c3                   	ret    

f0104224 <do_getc>:

int32_t do_getc()
{
f0104224:	83 ec 0c             	sub    $0xc,%esp
	return k_getc();
}
f0104227:	83 c4 0c             	add    $0xc,%esp
	}
}

int32_t do_getc()
{
	return k_getc();
f010422a:	e9 f1 d8 ff ff       	jmp    f0101b20 <k_getc>

f010422f <do_syscall>:
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f010422f:	53                   	push   %ebx
	int32_t retVal = -1;
f0104230:	83 c8 ff             	or     $0xffffffff,%eax
{
	return k_getc();
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104233:	83 ec 08             	sub    $0x8,%esp
f0104236:	8b 4c 24 10          	mov    0x10(%esp),%ecx
f010423a:	8b 54 24 14          	mov    0x14(%esp),%edx
f010423e:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	int32_t retVal = -1;
	extern Task *cur_task;

	switch (syscallno)
f0104242:	83 f9 0a             	cmp    $0xa,%ecx
f0104245:	0f 87 85 00 00 00    	ja     f01042d0 <do_syscall+0xa1>
f010424b:	ff 24 8d 44 66 10 f0 	jmp    *-0xfef99bc(,%ecx,4)
		retVal = 0;
    		break;

	}
	return retVal;
}
f0104252:	83 c4 08             	add    $0x8,%esp
f0104255:	5b                   	pop    %ebx
	case SYS_fork:
		/* TODO: Lab 5
     * You can reference kernel/task.c, kernel/task.h
     */
		//create process
		retVal = sys_fork(); //In task.c
f0104256:	e9 f8 fc ff ff       	jmp    f0103f53 <sys_fork>
		retVal = 0;
    		break;

	}
	return retVal;
}
f010425b:	83 c4 08             	add    $0x8,%esp
f010425e:	5b                   	pop    %ebx
	}
}

int32_t do_getc()
{
	return k_getc();
f010425f:	e9 bc d8 ff ff       	jmp    f0101b20 <k_getc>
	case SYS_getc:
		retVal = do_getc();
		break;

	case SYS_puts:
		do_puts((char*)a1, a2);
f0104264:	51                   	push   %ecx
f0104265:	51                   	push   %ecx
f0104266:	53                   	push   %ebx
f0104267:	52                   	push   %edx
f0104268:	e8 8f ff ff ff       	call   f01041fc <do_puts>
f010426d:	eb 55                	jmp    f01042c4 <do_syscall+0x95>
	case SYS_getpid:
		/* TODO: Lab 5
     * Get current task's pid
     */
		//old Lab4: get current task's pid
		retVal = cur_task->task_id;
f010426f:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0104274:	8b 00                	mov    (%eax),%eax
		break;
f0104276:	eb 58                	jmp    f01042d0 <do_syscall+0xa1>
		/* TODO: Lab 5
     * Yield this task
     * You can reference kernel/sched.c for yielding the task
     */
		//old Lab4 TODO: set task to sleep state and yield this task.
		cur_task->state = TASK_SLEEP;
f0104278:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
		cur_task->remind_ticks = a1;
f010427d:	89 50 4c             	mov    %edx,0x4c(%eax)
		/* TODO: Lab 5
     * Yield this task
     * You can reference kernel/sched.c for yielding the task
     */
		//old Lab4 TODO: set task to sleep state and yield this task.
		cur_task->state = TASK_SLEEP;
f0104280:	c7 40 50 03 00 00 00 	movl   $0x3,0x50(%eax)
		cur_task->remind_ticks = a1;
		sched_yield();
f0104287:	e8 8c 00 00 00       	call   f0104318 <sched_yield>
f010428c:	eb 0c                	jmp    f010429a <do_syscall+0x6b>
     * Kill specific task
     * You can reference kernel/task.c, kernel/task.h
     */
		//old Lab4 TODO: kill task.
		//printk("before sys_kill, %d\n",cur_task->task_id);
		sys_kill(a1);
f010428e:	83 ec 0c             	sub    $0xc,%esp
f0104291:	52                   	push   %edx
f0104292:	e8 34 fc ff ff       	call   f0103ecb <sys_kill>
		break;
f0104297:	83 c4 10             	add    $0x10,%esp
	return k_getc();
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	int32_t retVal = -1;
f010429a:	83 c8 ff             	or     $0xffffffff,%eax
     * You can reference kernel/task.c, kernel/task.h
     */
		//old Lab4 TODO: kill task.
		//printk("before sys_kill, %d\n",cur_task->task_id);
		sys_kill(a1);
		break;
f010429d:	eb 31                	jmp    f01042d0 <do_syscall+0xa1>
		retVal = 0;
    		break;

	}
	return retVal;
}
f010429f:	83 c4 08             	add    $0x8,%esp
f01042a2:	5b                   	pop    %ebx

  case SYS_get_num_free_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
		retVal = sys_get_num_free_page();
f01042a3:	e9 86 f9 ff ff       	jmp    f0103c2e <sys_get_num_free_page>
		retVal = 0;
    		break;

	}
	return retVal;
}
f01042a8:	83 c4 08             	add    $0x8,%esp
f01042ab:	5b                   	pop    %ebx

  case SYS_get_num_used_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
		retVal = sys_get_num_used_page();
f01042ac:	e9 83 f9 ff ff       	jmp    f0103c34 <sys_get_num_used_page>
		retVal = 0;
    		break;

	}
	return retVal;
}
f01042b1:	83 c4 08             	add    $0x8,%esp
f01042b4:	5b                   	pop    %ebx

  case SYS_get_ticks:
		/* TODO: Lab 5
     * You can reference kernel/timer.c
     */
    retVal = sys_get_ticks();
f01042b5:	e9 c2 fa ff ff       	jmp    f0103d7c <sys_get_ticks>

  case SYS_settextcolor:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
		sys_settextcolor(a1, 0);
f01042ba:	50                   	push   %eax
f01042bb:	50                   	push   %eax
f01042bc:	6a 00                	push   $0x0
f01042be:	52                   	push   %edx
f01042bf:	e8 51 da ff ff       	call   f0101d15 <sys_settextcolor>
		retVal = 0;
    		break;
f01042c4:	83 c4 10             	add    $0x10,%esp
f01042c7:	eb 05                	jmp    f01042ce <do_syscall+0x9f>

  case SYS_cls:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
		sys_cls();
f01042c9:	e8 fb d8 ff ff       	call   f0101bc9 <sys_cls>
		retVal = 0;
f01042ce:	31 c0                	xor    %eax,%eax
    		break;

	}
	return retVal;
}
f01042d0:	83 c4 08             	add    $0x8,%esp
f01042d3:	5b                   	pop    %ebx
f01042d4:	c3                   	ret    

f01042d5 <syscall_handler>:

static void syscall_handler(struct Trapframe *tf)
{
f01042d5:	53                   	push   %ebx
f01042d6:	83 ec 10             	sub    $0x10,%esp
f01042d9:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	*/


	int32_t ret = -1;
	// call do_syscall and pass the parmeters from tf
	ret = do_syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
f01042dd:	ff 73 04             	pushl  0x4(%ebx)
f01042e0:	ff 33                	pushl  (%ebx)
f01042e2:	ff 73 10             	pushl  0x10(%ebx)
f01042e5:	ff 73 18             	pushl  0x18(%ebx)
f01042e8:	ff 73 14             	pushl  0x14(%ebx)
f01042eb:	ff 73 1c             	pushl  0x1c(%ebx)
f01042ee:	e8 3c ff ff ff       	call   f010422f <do_syscall>

	/* Set system return value */
	tf->tf_regs.reg_eax = ret;
f01042f3:	89 43 1c             	mov    %eax,0x1c(%ebx)

}
f01042f6:	83 c4 28             	add    $0x28,%esp
f01042f9:	5b                   	pop    %ebx
f01042fa:	c3                   	ret    

f01042fb <syscall_init>:

void syscall_init()
{
f01042fb:	83 ec 18             	sub    $0x18,%esp
   * Please set gate of system call into IDT
   * You can leverage the API register_handler in kernel/trap.c
   */
	extern void SYSCALL();
//	register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
	register_handler(T_SYSCALL, syscall_handler, SYSCALL, 0, 3);
f01042fe:	6a 03                	push   $0x3
f0104300:	6a 00                	push   $0x0
f0104302:	68 42 21 10 f0       	push   $0xf0102142
f0104307:	68 d5 42 10 f0       	push   $0xf01042d5
f010430c:	6a 30                	push   $0x30
f010430e:	e8 32 dc ff ff       	call   f0101f45 <register_handler>
	// then declare SYSCALL in entry_trap.S

}
f0104313:	83 c4 2c             	add    $0x2c,%esp
f0104316:	c3                   	ret    
	...

f0104318 <sched_yield>:
*
* 4. CONTEXT SWITCH, leverage the macro ctx_switch(ts)
*    Please make sure you understand the mechanism.
*/
void sched_yield(void)
{
f0104318:	55                   	push   %ebp
f0104319:	57                   	push   %edi
f010431a:	56                   	push   %esi
f010431b:	53                   	push   %ebx
	int next_i = 0;

	/* Implement a simple round-robin scheduling there 
	*  Hint: Choose a runnable task from tasks[] and use env_pop_tf() do the context-switch
	*/
	i = (cur_task->task_id + 1) % NR_TASKS;
f010431c:	bb 0a 00 00 00       	mov    $0xa,%ebx
*
* 4. CONTEXT SWITCH, leverage the macro ctx_switch(ts)
*    Please make sure you understand the mechanism.
*/
void sched_yield(void)
{
f0104321:	83 ec 0c             	sub    $0xc,%esp
	int next_i = 0;

	/* Implement a simple round-robin scheduling there 
	*  Hint: Choose a runnable task from tasks[] and use env_pop_tf() do the context-switch
	*/
	i = (cur_task->task_id + 1) % NR_TASKS;
f0104324:	8b 0d 2c 4e 11 f0    	mov    0xf0114e2c,%ecx
f010432a:	8b 01                	mov    (%ecx),%eax
f010432c:	40                   	inc    %eax
f010432d:	99                   	cltd   
f010432e:	f7 fb                	idiv   %ebx
	for (; next_i < NR_TASKS; next_i++)
	{
		if (tasks[i].state == TASK_RUNNABLE)
f0104330:	6b fa 58             	imul   $0x58,%edx,%edi
f0104333:	8d 87 d8 76 11 f0    	lea    -0xfee8928(%edi),%eax
f0104339:	8b 68 50             	mov    0x50(%eax),%ebp
f010433c:	8d 70 50             	lea    0x50(%eax),%esi
f010433f:	83 fd 01             	cmp    $0x1,%ebp
f0104342:	75 2f                	jne    f0104373 <sched_yield+0x5b>
		{
			if (cur_task->state == TASK_RUNNING)
f0104344:	8b 79 50             	mov    0x50(%ecx),%edi
f0104347:	83 ff 02             	cmp    $0x2,%edi
f010434a:	75 10                	jne    f010435c <sched_yield+0x44>
			{
				cur_task->state = TASK_RUNNABLE;
f010434c:	c7 41 50 01 00 00 00 	movl   $0x1,0x50(%ecx)
				cur_task->remind_ticks = TIME_QUANT;
f0104353:	c7 41 4c 64 00 00 00 	movl   $0x64,0x4c(%ecx)
f010435a:	eb 0a                	jmp    f0104366 <sched_yield+0x4e>
				cur_task = &tasks[i];
				tasks[i].state = TASK_RUNNING;
				break;
			} else if (cur_task->state == TASK_SLEEP)
f010435c:	83 ff 03             	cmp    $0x3,%edi
f010435f:	74 05                	je     f0104366 <sched_yield+0x4e>
			{
				cur_task = &tasks[i];
				tasks[i].state = TASK_RUNNING;//TASK_RUNNING  TASK_RUNNABLE
				break;
			} else if (cur_task->state == TASK_STOP) {
f0104361:	83 ff 04             	cmp    $0x4,%edi
f0104364:	75 1e                	jne    f0104384 <sched_yield+0x6c>
				cur_task = &tasks[i];
f0104366:	a3 2c 4e 11 f0       	mov    %eax,0xf0114e2c
				tasks[i].state = TASK_RUNNING;//TASK_RUNNING  TASK_RUNNABLE
f010436b:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
				break;
f0104371:	eb 27                	jmp    f010439a <sched_yield+0x82>
			}
		} else if ( tasks[i].state == TASK_RUNNING)
f0104373:	83 fd 02             	cmp    $0x2,%ebp
f0104376:	75 0c                	jne    f0104384 <sched_yield+0x6c>
		{
			cur_task = &tasks[i];
f0104378:	89 c1                	mov    %eax,%ecx
			tasks[i].remind_ticks = TIME_QUANT;
f010437a:	c7 87 24 77 11 f0 64 	movl   $0x64,-0xfee88dc(%edi)
f0104381:	00 00 00 

	/* Implement a simple round-robin scheduling there 
	*  Hint: Choose a runnable task from tasks[] and use env_pop_tf() do the context-switch
	*/
	i = (cur_task->task_id + 1) % NR_TASKS;
	for (; next_i < NR_TASKS; next_i++)
f0104384:	4b                   	dec    %ebx
f0104385:	74 0d                	je     f0104394 <sched_yield+0x7c>
		} else if ( tasks[i].state == TASK_RUNNING)
		{
			cur_task = &tasks[i];
			tasks[i].remind_ticks = TIME_QUANT;
		}
		i = (i + 1) % NR_TASKS;
f0104387:	8d 42 01             	lea    0x1(%edx),%eax
f010438a:	be 0a 00 00 00       	mov    $0xa,%esi
f010438f:	99                   	cltd   
f0104390:	f7 fe                	idiv   %esi
f0104392:	eb 9c                	jmp    f0104330 <sched_yield+0x18>
f0104394:	89 0d 2c 4e 11 f0    	mov    %ecx,0xf0114e2c
	}

	//env_pop_tf(&cur_task->tf);
	lcr3(PADDR(cur_task->pgdir));	
f010439a:	8b 15 2c 4e 11 f0    	mov    0xf0114e2c,%edx
f01043a0:	8b 42 54             	mov    0x54(%edx),%eax
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01043a3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01043a8:	77 12                	ja     f01043bc <sched_yield+0xa4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01043aa:	50                   	push   %eax
f01043ab:	68 c2 54 10 f0       	push   $0xf01054c2
f01043b0:	6a 40                	push   $0x40
f01043b2:	68 70 66 10 f0       	push   $0xf0106670
f01043b7:	e8 84 f8 ff ff       	call   f0103c40 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01043bc:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01043c1:	0f 22 d8             	mov    %eax,%cr3
	ctx_switch(cur_task);
f01043c4:	83 ec 0c             	sub    $0xc,%esp
f01043c7:	83 c2 08             	add    $0x8,%edx
f01043ca:	52                   	push   %edx
f01043cb:	e8 de db ff ff       	call   f0101fae <env_pop_tf>
}
f01043d0:	83 c4 1c             	add    $0x1c,%esp
f01043d3:	5b                   	pop    %ebx
f01043d4:	5e                   	pop    %esi
f01043d5:	5f                   	pop    %edi
f01043d6:	5d                   	pop    %ebp
f01043d7:	c3                   	ret    

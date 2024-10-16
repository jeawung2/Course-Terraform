# 자주 사용되는 Terraform 내장 함수  

ⓘ Terraform에서 자주 사용되는 함수를 예시와 함께 소개한다.  

---
- [1. 문자열 함수](#1-문자열)
- [2. 집합 함수](#2-집합collection)
- [3. 파일시스템 함수](#3-파일시스템)
- [4. IP/네트워크 함수](#4-ip-네트워크)
- [5. 형식 변환 함수](#5-형식-변환)
---

> 아래 소개한 예시 외 더 상세한 내용은 아래 Terraform 공식 문서를 참고한다.  
https://developer.hashicorp.com/terraform/language/functions 

---

## 1. 문자열

### 1) format

문자열 포멧팅

형식::

```
format(spec, values...)
```

예:

```
> format("Hello, %s!", "Ander")
Hello, Ander!
```

```
> format("There are %d lights", 4)
There are 4 lights
```

### 2) formatlist

문자열 목록 포멧팅

형식::

```
formatlist(spec, values...)
```

예:

```
> formatlist("Hello, %s!", ["Valentina", "Ander", "Olivia", "Sam"])
[
  "Hello, Valentina!",
  "Hello, Ander!",
  "Hello, Olivia!",
  "Hello, Sam!",
]
```

```
> formatlist("%s, %s!", "Salutations", ["Valentina", "Ander", "Olivia", "Sam"])
[
  "Salutations, Valentina!",
  "Salutations, Ander!",
  "Salutations, Olivia!",
  "Salutations, Sam!",
]
```

### 3) join

문자열 목록을 구분 기호로 연결

형식::

```
join(separator, list)
```

예:

```
> join("-", ["foo", "bar", "baz"])
"foo-bar-baz"
```

```
> join(",", ["foo", "bar", "baz"])
foo, bar, baz
```

```
> join(",", ["foo"])
foo
```

### 4) lower

소문자 변환

예:

```
> lower("HELLO")
hello
```

```
> lower("АЛЛО!")
алло!
```

### 5) upper

예:

```
> upper("hello")
HELLO
```

```
> upper("алло!")
АЛЛО!

```

### 6) regex

정규화 표현식

형식::

```
regex(pattern, string)
```

예:

```
> regex("[a-z]+", "53453453.345345aaabbbccc23454")
aaabbbccc
```

```
> regex("(\\d\\d\\d\\d)-(\\d\\d)-(\\d\\d)", "2019-02-01")
[
  "2019",
  "02",
  "01",
]
```

### 7) replace

문자열 대체

형식::

```
replace(string, substring, replacement)
```

예:

```
> replace("1 + 2 + 3", "+", "-")
1 - 2 - 3
```

```
> replace("hello world", "/w.*d/", "everybody")
hello everybody
```

### 8) split

문자열을 지정된 구분 기호를 이용해 분할하여 목록 생성

형식::

```
split(separator, string)
```

예:

```
> split(",", "foo,bar,baz")
[
  "foo",
  "bar",
  "baz",
]
```

```
> split(",", "foo")
[
  "foo",
]
```

### 9) substr

문자열에서 특정 위치의 특정 길이만큼 문자열 추출

형식::

```
substr(string, offset, length)
```

예:

```
> substr("hello world", 1, 4)
ello
```

```
> substr("🤔🤷", 0, 1)
🤔
```

## 2. 집합(Collection)

### 1) coalesce

문자열에서 널(Null) 또는 빈 문자열이 아닌 첫 번째 문자열을 반환

예:

```
> coalesce("a", "b")
a
```

```
> coalesce("", "b")
b
```

```
> coalesce(1, "hello")
"1"
```

### 2) coalescelist

문자열 목록에서 널(Null) 또는 빈 문자열이 아닌 첫 번째 문자열을 반환

예:

```
> coalescelist(["a", "b"], ["c", "d"])
[
  "a",
  "b",
]
```

```
> coalescelist([], ["c", "d"])
[
  "c",
  "d",
]
```

### 3) concat

하나 이상의 목록을 하나의 목록으로 결합

예:

```
> concat(["a", "b"], ["c", "d"])
[
  "a",
  "b",
  "c",
  "d",
]
```

### 4) contains

목록 또는 집합에서 특정 문자가 포함되었는지 확인

형식:

```
contains(list, value)
```

예:

```
> contains(["a", "b", "c"], "a")
true
```

```
> contains(["a", "b", "c"], "d")
false
```

### 5) distinct

목록에서 중복 요소 제거

예:

```
> distinct(["a", "b", "a", "c", "d", "b"])
[
  "a",
  "b",
  "c",
  "d",
]
```

### 6) flatten

하나 이상의 목록을 받아 모든 목록의 요소를 플랫한 목록으로 변경

예:

```
> flatten([["a", "b"], [], ["c"]])
["a", "b", "c"]
```

```
> flatten([[["a", "b"], []], ["c"]])
["a", "b", "c"]
```

### 7) length

목록, 맵, 문자열의 길이

예:

```
> length([])
0
```

```
> length(["a", "b"])
2
```

```
> length({"a" = "b"})
1
```

```
> length("hello")
5
```

### 8) lookup

지정된 맵에서 키의 값을 검색해 반환, 만약 키가 없다면 기본값으로 반환

형식:

```
lookup(map, key, default)
```

예:

```
> lookup({a="ay", b="bee"}, "a", "what?")
ay
```

```
> lookup({a="ay", b="bee"}, "c", "what?")
what?
```

### 9) merge

하나 이상의 맵 또는 오브젝트를 받아 병합된 단일 맵 또는 단일 오브젝트 반환

중복 키가 있는 경우, 나중에 나온 값이 우선됨

예:

```
> merge({a="b", c="d"}, {e="f", c="z"})
{
  "a" = "b"
  "c" = "z"
  "e" = "f"
}
```

```
> merge({a="b"}, {a=[1,2], c="z"}, {d=3})
{
  "a" = [
    1,
    2,
  ]
  "c" = "z"
  "d" = 3
}
```

### 10) reverse

목록을 역순으로 배열

예:

```
> reverse([1, 2, 3])
[
  3,
  2,
  1,
]
```

### 11) slice

목록 내에서 특정 부분 추출

형식:

```
slice(list, startindex, endindex)
```

예:

```
> slice(["a", "b", "c", "d"], 1, 3)
[
  "b",
  "c",
]
```

### 12) sort

목록의 요소를 순서대로 정렬

예:

```
> sort(["e", "d", "a", "x"])
[
  "a",
  "d",
  "e",
  "x",
]
```

### 13) zipmap

키 목록과 값 목록을 받아 맵으로 변환

형식:

```
zipmap(keyslist, valueslist)
```

예:

```
> zipmap(["a", "b"], [1, 2])
{
  "a" = 1
  "b" = 2
}
```

## 3. 파일시스템

### 1) dirname

파일 경로를 나타내는 문자열에서 경로만 추출

예:

```
> dirname("foo/bar/baz.txt")
foo/bar
```

### 2) basename

파일 경로를 나타내는 문자열에서 파일만 추출

예:

```
> basename("foo/bar/baz.txt")
baz.txt
```

### 3) file

지정된 파일의 내용을 문자열로 반환

형식:

```
file(path)
```

예:

```
> file("${path.module}/hello.txt")
Hello World
```

### 4) filebase64

지정된 파일의 내용을 읽어 base64 인코딩된 문자열로 반환

형식:

```
filebase64(path)
```

예:

```
> filebase64("${path.module}/hello.txt")
SGVsbG8gV29ybGQ=
```

### 5) templatefile

지정된 파일의 내용일 읽고 제공된 템플릿 변수를 사용하여 렌더링

형식:

```
> templatefile("${path.module}/backends.tftpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
backend 10.0.0.1:8080
backend 10.0.0.2:8080
```

예:

```
templatefile(path, vars)
```

## 4. IP 네트워크

### 1) cidrnetmask

네트워크 CIDR의 접두사를 서브넷 마스크 주소로 변환

형식:

```
cidrhost(prefix, hostnum)
```

예:

```
> cidrnetmask("172.16.0.0/12")
255.240.0.0
```

### 2) cidrsubnets

특정 네트워크에서 서브넷팅된 네트워크 대역의 목록 반환

형식:

```
cidrsubnets(prefix, newbits...)
```

예:

```
> cidrsubnets("10.1.0.0/16", 4, 4, 8, 4)
[
  "10.1.0.0/20",
  "10.1.16.0/20",
  "10.1.32.0/24",
  "10.1.48.0/20",
]
```

## 5. 형식: 변환

### 1) tolist

목록으로 변환

듀플 -> 목록

예:

```
> tolist(["a", "b", "c"])
[
  "a",
  "b",
  "c",
]
```

```
> tolist(["a", "b", 3])
[
  "a",
  "b",
  "3",
]
```

### 2) tomap

맵으로 변환

오브젝트 -> 맵

예:

```
> tomap({"a" = 1, "b" = 2})
{
  "a" = 1
  "b" = 2
}
```

```
> tomap({"a" = "foo", "b" = true})
{
  "a" = "foo"
  "b" = "true"
}
```

### 3) toset

세트로 변환

예:

```
> toset(["a", "b", 3])
[
  "3",
  "a",
  "b",
]
```

```
> toset(["c", "b", "b"])
[
  "b",
  "c",
]
```

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>

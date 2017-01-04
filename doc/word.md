# 述語

```
uint64.word
double.word
```

## byte

### string.byte(s[, i[, j]])

> Returns the internal numeric codes of the characters s[i], s[i+1], ..., s[j]. The default value for i is 1; the default value for j is i. These indices are corrected following the same rules of function string.sub.

## pack

### table.pack(...)

> Returns a new table with all parameters stored into keys 1, 2, etc. and with a field "n" with the total number of parameters. Note that the resulting table may not be a sequence.

### string.pack(fmt, v1, v2, ...)

> Returns a binary string containing the values v1, v2, etc. packed (that is, serialized in binary form) according to the format string fmt (see §6.4.2).

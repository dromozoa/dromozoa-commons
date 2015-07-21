# uint32

符号無し32bit整数を操作する。

## 方針

当初は、速度をあまり重視しない実装を行う。速度が重要であれば、コンパイラを作成して最適化を行う。

## 操作

### Lua 5.3の命令セット

* `+`: `ADD`
* `-`: `SUB`
* `*`: `MUL`
* `/`: `DIV`
* `//`: `IDIV`
* `%`: `MOD`
* `^`: `POW`
* `-`: `UNM`
* `&`: `BAND`
* `|`: `BOR`
* `~`: `BXOR`
* `>>`: `SHR`
* `<<`: `SHL`
* `~`: `BNOT`

余が発生しない演算であっても、`DIV`の結果は浮動小数点数になるので注意する。Lua 5.3であることが判っていれば`IDIV`を使う。バージョンに依存したくなければ`math.floor`を使って明示的に整数に変換する。

### bit32 (Lua 5.2)

* `arshit`
* `band`
* `bnot`
* `bor`
* `btest`
* `bxor`
* `extract`
* `lrotate`
* `lsfhit`
* `rrotate`
* `rshift`

### Lua BitOp (LuaJIT)

* `tobit`
* `tohex`
* `bnot`
* `bor`
* `band`
* `bxor`
* `lshift`
* `rshift`
* `arshift`
* `rol`
* `ror`
* `bswap`

`int32_t`にキャストしてから値を返す。`lua_Number`が`double`ならば、`0x100000000`の剰余をとれば`uint32_t`として扱うことができる。

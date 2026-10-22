# Nip: Nix Project Manager

Nix flakes なプロジェクトを npm ライクに管理できるラッパー

## cli

### `nip add <ref...>`

`nixpkgs#python3` を参照するための宣言を `inputs.nix` に追加します。

`-f` オプションで出力先を変えることができます。

```bash
nip add nixpkgs#python3
```

## flakes

### `nip.lib.from :: deps -> inputs -> system -> [drv]`

- deps: `nip add` で生成される宣言
- inputs: flake の入力
- system: 依存関係を収集するためのプラットフォーム名

```nix
nip.lib.from {
  nixpkgs = [ "python3" ];
} {
  nixpkgs = builtins.getFlake "nixpkgs";
} "x86_64-linux"
# [
#   <derivation python3>
# ]
```

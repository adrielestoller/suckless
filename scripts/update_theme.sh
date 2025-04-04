#!/bin/bash

xresources_path="$HOME/.Xresources"
color_properties_path="$HOME/.cache/wal/colors.properties"

# Verifica se os arquivos existem
if [ ! -f "$xresources_path" ]; then
  echo "Erro: Arquivo .Xresources não encontrado em $xresources_path"
exit 1
fi

if [ ! -f "$color_properties_path" ]; then
	echo "Erro: Arquivo color.properties não encontrado em $color_properties_path"
	exit 1
fi

# Extrai as cores do color.properties
declare -A colors
while IFS='=' read -r key value; do
	if [[ "$key" == color* ]]; then
		colors["\${$key}"]="$value"
	fi
done < "$color_properties_path"

# Define as linhas do dwm com os placeholders
dwm_lines=(
	"dwm.normbordercolor: \${color9}"
	"dwm.normbgcolor:			\${color0}"
	"dwm.normfgcolor:			\${color7}"
	"dwm.selbordercolor:	\${color9}"
	"dwm.selbgcolor:			\${color4}"
	"dwm.selfgcolor:			\${color0}"
)

# Define as linhas do st com os placeholders
st_lines=(
	"st.foreground:   \${color7}"
	"st.background:   \${color0}"
	"st.cursorColor:  \${color7}"
)

# Define as linhas do dmenu (AJUSTE OS NOMES DAS OPÇÕES!!!)
dmenu_lines=(
	"dmenu.normfgcolor:     \${color7}"
	"dmenu.normbgcolor:     \${color0}"
	"dmenu.selfgcolor:      \${color0}"
	"dmenu.selbgcolor:      \${color7}"
	"dmenu.fuzzyfg:					\${color0}"  # Exemplo - Cor do realce fuzzy
	"dmenu.fuzzybg:					\${color6}" # Exemplo - Fundo do realce fuzzy
)

# Cria o novo .Xresources no arquivo temporário
temp_file=$(mktemp)
echo "! dwm colors" >> "$temp_file"
for line in "${dwm_lines[@]}"; do
	new_line="$line"
  for placeholder in "${!colors[@]}"; do
		new_line="${new_line//$placeholder/${colors[$placeholder]}}"
  done
  echo "$new_line" >> "$temp_file"
done

echo "" >> "$temp_file"

# Cores para st (adicionado aqui - Mantendo a estrutura original)
echo "! Cores para st (adicionadas automaticamente)" >> "$temp_file"
for line in "${st_lines[@]}"; do
  new_line="$line"
  for placeholder in "${!colors[@]}"; do
    new_line="${new_line//$placeholder/${colors[$placeholder]}}"
  done
  echo "$new_line" >> "$temp_file"
done

echo "" >> "$temp_file"

# Cores para dmenu (AJUSTE OS NOMES DAS OPÇÕES!!!)
echo "! Cores para dmenu (adicionadas automaticamente)" >> "$temp_file"
for line in "${dmenu_lines[@]}"; do
  new_line="$line"
  for placeholder in "${!colors[@]}"; do
    new_line="${new_line//$placeholder/${colors[$placeholder]}}"
  done
  echo "$new_line" >> "$temp_file"
done

# *** ADICIONE AQUI OUTRAS CONFIGURAÇÕES DO SEU .Xresources QUE VOCÊ DESEJA MANTER ***
# Exemplo:
# echo "! Outras configurações" >> "$temp_file"
# echo "URxvt.font: xft:monospace:pixelsize=16" >> "$temp_file"
# echo "Xcursor.theme: default" >> "$temp_file"

# Substitui o .Xresources original pelo arquivo modificado
mv "$temp_file" "$xresources_path"

# Aplica as alterações
xrdb "$xresources_path"
	
echo "Colorscheme atualizado com sucesso!"

#!/bin/sh

ncol () {
	head -n 1 "$1" | awk -F '	' '{print NF}'
}

## substitute EXPRESSION_FILE MATH_FILE OUT_FILE
substitute () {
	NE=$(( `wc -l < "$1"` ))
	[ $((`ncol $2`)) -gt 1 ] && awk -F '	' '{print $2}' "$2" > "$3" || cp "$2" "$3"
	[ "$dir" ] && perl -i.rm -p "${dir}/math.sed" "$3"
	if [ -f "$1" ]; then
		for j in `seq $NE -1 1`; do
			ExpressionName=`awk -F '	' -v j=$((j)) 'NR==j {print $1}' "$1"`
			ExpressionFormula=`awk -F '	' -v j=$((j)) 'NR==j {print $2}' "$1"`
			perl -i.rm -p -e "s|\b${ExpressionName}\b|(${ExpressionFormula})|g;" -e 's|^.*[<>=]+.*$|0.0|g;' "$3"
		done
	fi
	[ "$dir" ] && perl -i.rm -p "${dir}/math.sed" "$3"
}


.text

main:
    addi $1 $0 5 # $1 <- 5
    lw $2 $0 arg # $2 <- data[arg]
    add $4 $2 $1 # $4 <- $2 + $1
    addi $5 $0 $1 # $5 <- 1
    
loop: sub $4 $4 $5 # $4 <- $4 - $5
    bne $4 $0 loop # branch if not equal
    .data
    arg: .word 12
# Simple-9-bit-Processor
### bit breakdowns: 

|3 bit    |3 bit         |     1 bit +2 bit  |  
| :--- | :----:| ---:|
|opcode | registers  | (func+consant)  or  registers |

### Instructions:
|Instruction	|opcode	|func	|syntax	|	result|
| :---        | :----:| :----:|   :----:|         :---: |
|add|		000	|1	|add rd rs	|rd= rd+rs
|sub|		000	|0	|sub rd rs	|rd= rd-rs
|mov|		001	|X	|mov rd imm	|rd= imm
|		|		    |   |mov rd sp	|sp=rd
|		|		    |   |mov sp rd	|rd=sp
|lft|		010	|0	|lft rd imm	|rd=rd<<imm
|rft|		010	|1	|rft rd imm	|rd=rd>>imm
|ste|		011	|x	|ste sp rs	|[sp]=rs
|lod|		011	|x	|lod rd sp	|rd=[sp]
|lup|		100	|x	|lup rd		|rd =LFSR_ptrn[rd]
|		|		    |    |lup rd rs	|rd=LFSR_prog2_LUT[{rd,rs}]
|xor|		101	|x|	xor rd		|rd=^rd
|		|	      |x	|xor rd rs	|rd=rd^rs
|lfsr|		110	|x	|lfsr rd rs	|rd ={0,(rd<<1)|(^(rd & rs))}
|bne	|	111	|x	|bne rd rs|	bracnch if rd !=rs 
|halt|		000	|0	|halt		|program end


<p>note:</p> 
  <ol>
<li><strong>sp</strong> is registers number 8, only <strong>sp</strong> are allowed to access memey </li>
<li>number of registers : <strong>8</strong> </li>
<li>if <strong>bne</strong> succes then pc would read the next instruction which are the label.</li>
<li><strong>lod</strong> and <strong>ste</strong> are using the same opcode, the different is on the position of <strong>sp</strong>.</li>
<li><strong>lfsr</strong> is used to decode character.</li>
<li><strong>lup</strong> is used to look up lfsr patterns.</li>
  </ol>

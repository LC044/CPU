begin
                        if (a[31] != b[31])
                                begin
                                if(a[31]==1) c = 1;
                                else c = 0;
                                end
                        else
                        begin
                                if(a[30:0]<b[30:0]) c = 1;
                                else c = 0;
                        end
                        end
begin 
                                case({a[31],b[31]})
                                        2'b00: c = (a[30:0]<b[30:0])?1:0;
                                        2'b01: c = 0;
                                        2'b10: c = 1;
                                        2'b11: c = (a[30:0]<b[30:0])?1:0;
                                endcase
                        end


// always @(aluop ,a,b) //always后面的内容表示内容改变时执行always之后的内容
//     begin
//         case(aluop)
//             4'b0001:     c = a+b ;
//             4'b0011:     c = a-b ;
//             4'b0000:     c = a+b ;
//             4'b0100:     c = a&b ;
//             4'b0101:     c = a|b ;  
//             4'b1010:   begin 
//                                 case({a[31],b[31]})
//                                         2'b00: c = (a[30:0]<b[30:0])?1:0;
//                                         2'b01: c = 0;
//                                         2'b10: c = 1;
//                                         2'b11: c = (a[30:0]<b[30:0])?1:0;
//                                 endcase
//                         end
//         default:         c = 32'h0123 ;
//     endcase 
//     end
// 2
// 3
// 10
// 11
// 10
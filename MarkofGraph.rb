#! /usr/bin/ruby -w
# Exercise for Markof transferring matrix

class CrossLinkNode
    attr_accessor(:val);                        # value
    attr_reader(:line, :column);                # position in matrix
    attr_accessor(:left, :right, :up, :down);   # pointer to neighbor

    def initialize(val, line, column,
                   left = nil, right = nil, up = nil, down = nil)
        @val = val;
        @line = line;
        @column = column;
        @left = left;
        @right = right;
        @up = up;
        @down = down;
    end

    def delete
        @left.right = @right if(left);
        @right.left = @left if(right);
        @up.down = @down if(up);
        @down.up = @up if(down);
    end
end

class CrossLinkMatrix
    attr_reader(:state_cnt, :trans_cnt);

    def initialize(state_cnt = 0)
        @state_cnt = state_cnt;
        @trans_cnt = 0;
        @line_head = Array.new(@state_cnt, nil);
        @column_head = Array.new(@state_cnt, nil);
    end

    # set a new trans_matrix value
    # if the node existed, refresh the value
    # else, create new node and insert it in the cross link_list
    def add_trans(val, line, column)
        new_node = CrossLinkNode.new(val, line, column);
        # insert trans node in line link_list
        if(@line_head[line] == nil)
            @line_head[line] = new_node;
            @trans_cnt += 1;
        elsif(@line_head[line].column > column)
            new_node.right = @line_head[line];
            @line_head[line].left = new_node;
            @line_head[line] = new_node;
            @trans_cnt += 1;
        else
            cur_node = @line_head[line];
            while((cur_node != nil) && (cur_node.column < column))
                last_node = cur_node;
                cur_node = cur_node.right;
                if(cur_node == nil)
                    last_node.right = new_node; # add node in the end
                    @trans_cnt += 1;
                else
                    if(cur_node.column == column)
                        cur_node.val = val;     # refresh the value in node
                    elsif(cur_node.column > column) # insert the node
                        last_node.right = new_node;
                        new_node.right = cur_node;
                        new_node.left = last_node;
                        cur_node.left = new_node;
                        @trans_cnt += 1;
                    end
                end
            end
        end
        # insert trans node in column link_list
        if(@column_head[column] == nil)
            @column_head[column] = new_node;
        elsif(@column_head[column].line > line)
            new_node.down = @column_head[column];
            @column_head[column].up = new_node;
            @column_head[column] = new_node;
            @trans_cnt += 1;
        else
            cur_node = @column_head[column];
            while((cur_node != nil) && (cur_node.line < line))
                last_node = cur_node;
                cur_node = cur_node.down;
                if(cur_node == nil)
                    last_node.down = new_node; # add node in the end
                else    # if the node existed, it must have been refresh in line
                    if(cur_node.line > line)    # insert the node
                        last_node.down = new_node;
                        new_node.down = cur_node;
                        new_node.up = last_node;
                        cur_node.up = new_node;
                    end
                end
            end
        end
    end

    # search node in line link_list
    def search_in_line(line, column)
        cur_node = @line_head[line];
        if(cur_node == nil)
            # empty node, return 0 as value
            return 0;
        else
            while((cur_node.column < column) && (cur_node.right != nil))
                cur_node = cur_node.right;
            end
            if(cur_node.column == column)
                # search success
                return cur_node.val;
            else
                # empty node, return 0 as value
                return 0;
            end
        end
    end

    # search node in column link_list
    def search_in_column(line, column)
        cur_node = @column_head[column];
        if(cur_node == nil)
            # empty node, return 0 as value
            return 0;
        else
            while((cur_node.line < line) && (cur_node.down != nil))
                cur_node = cur_node.down;
            end
            if(cur_node.line == line)
                # search success
                return cur_node.val;
            else
                # empty node, return 0 as value
                return 0;
            end
        end
    end

end

BEGIN {
    print("This program is used for Markof Link.\n");
    print("Described by Graph and Matrix + Cross Link.\n");
}

a = CrossLinkNode.new(0, 1, 1);
print("#{a.class}\n");
print("#{a.respond_to?(:column)}\n");
print("column=#{a.column}\n");

state2 = Array.new(2, 0);
tran_m2 = CrossLinkMatrix.new(2);
tran_m2.add_trans(0.6, 0, 1);
tran_m2.add_trans(0.4, 0, 0);
tran_m2.add_trans(0.7, 1, 0);
tran_m2.add_trans(0.3, 1, 1);
print("#{tran_m2.state_cnt}, #{tran_m2.trans_cnt}\n");

2.times {|i|
    2.times {|j|
        print("[#{i}, #{j}]: #{tran_m2.search_in_line(i, j)}, ");
    }
    print("\n");
}
2.times {|i|
    2.times {|j|
        print("[#{i}, #{j}]: #{tran_m2.search_in_column(i, j)}, ");
    }
    print("\n");
}

END {
    print("Program End.\n");
}
__END__
2017.Jul.27

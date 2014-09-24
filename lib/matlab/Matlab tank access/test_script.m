%Test something

actxname = ttank;
[tanknames,ntanks] = get_tanknames(actxname);
tanknum = 4;
tankname = tanknames{tanknum}.name;
[blocknames,nblocks] = get_blocknames(actxname,tankname);
blocknum = 9;
blockname = blocknames{blocknum}.name;

global ttank
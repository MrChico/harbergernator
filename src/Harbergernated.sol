import "./harbergernated.sol";
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice ERC-721 Harberger tax.
/// @author Mrchico, adapted from Solmate
contract HarbergedERC721 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    event Approval(address indexed owner, address indexed spender, uint256 indexed id);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /*//////////////////////////////////////////////////////////////
                         METADATA STORAGE/LOGIC
    //////////////////////////////////////////////////////////////*/

    string public constant name;

    string public constant symbol;

    function tokenURI(uint256 id) public view returns (string memory) {
	return parent.tokenURI(id);
    };

    /*//////////////////////////////////////////////////////////////
                      ERC721 BALANCE/OWNER STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(uint256 => address) public ownerOf;

    mapping(address => uint256) public balanceOf;

    /*//////////////////////////////////////////////////////////////
                         ERC721 APPROVAL STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(uint256 => address) public getApproved;

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(ERC721 _parent) {
	harbergernator = msg.sender;
        name = _parent.name();
	symbol = _parent.symbol();
    }

    /*//////////////////////////////////////////////////////////////
                              ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 id) public virtual {
        address owner = _ownerOf[id];

        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");

        getApproved[id] = spender;

        emit Approval(owner, spender, id);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual {
        require(from == ownerOf[id], "WRONG_FROM");
        require(to != address(0), "INVALID_RECIPIENT");

        require(
            msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
            "NOT_AUTHORIZED"
        );

        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        unchecked {
            balanceOf[from]--;

            balanceOf[to]++;
        }

        ownerOf[id] = to;

        delete getApproved[id];

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
                ERC721TokenReceiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes calldata data
    ) public virtual {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
                ERC721TokenReceiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }

    

    /*//////////////////////////////////////////////////////////////
                        MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/
    function mint(address to, uint256 id) public {
	require(msg.sender == harbergernator, "NOT HARBERGENATOR");
	_mint(to, id);
    }

    function burn(uint256 id) public {
	require(msg.sender == harbergernator, "NOT HARBERGENATOR");
	_burn(id);
    }

    function _mint(address to, uint256 id) internal virtual {
        require(to != address(0), "INVALID_RECIPIENT");

        require(ownerOf[id] == address(0), "ALREADY_MINTED");

        // Counter overflow is incredibly unrealistic.
        unchecked {
            _balanceOf[to]++;
        }

        ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function _burn(uint256 id) internal virtual {
        address owner = _ownerOf[id];

        require(owner != address(0), "NOT_MINTED");

        // Ownership check above ensures no underflow.
        unchecked {
            balanceOf[owner]--;
        }

        delete ownerOf[id];

        delete getApproved[id];

        emit Transfer(owner, address(0), id);
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL SAFE MINT LOGIC
    //////////////////////////////////////////////////////////////*/

    function _safeMint(address to, uint256 id) internal virtual {
        _mint(to, id);

        require(
            to.code.length == 0 ||
                ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
                ERC721TokenReceiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function _safeMint(
        address to,
        uint256 id,
        bytes memory data
    ) internal virtual {
        _mint(to, id);

        require(
            to.code.length == 0 ||
                ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
                ERC721TokenReceiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }
}

/// @notice A generic interface for a contract which properly accepts ERC721 tokens.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
abstract contract ERC721TokenReceiver {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}

 contract Harbergernator {
    mapping (address=>address) wrappedTokens public;
    ERC20 money public;
    mapping (address=>mapping(uint256=>uint256)) time public;
    mapping (address=>mapping(uint256=>address)) lords public;
    mapping (address=>mapping(uint256=>uint256)) prices public;
    mapping (address=>mapping(uint256=>uint256)) balance public;

    function harbergernate(address token, uint256 tokenId, uint256 rate, uint256 initialPrice, address lord) public {
	Harbergednated wrapped = wrappedTokens[token];
	if (wrapped != address(0)) {
	    wrapped = new Harbergernated(parent);
	    wrappedTokens[parent] = address(_wrapped);
	}
	token.transferFrom(msg.sender, address(this), tokenId);
	wrapped.mint(tokenId);
	lords[token][tokenId] = lord;
    }
    
    function buy(address token, uint256 tokenId, address newOwner, uint256 deposit) public {
	address currentOwner = wrappedTokens[token].ownerOf(tokenId);
	money.transferFrom(address(this), currentOwner, balance[token][tokenId]);
	money.transferFrom(msg.sender,    currentOwner, prices[token][tokenId] + deposit);
	Harbergernated(wrappedTokens[token]).transferFrom(currentOwner, msg.sender, tokenId);
	balance[token][tokenId] += deposit;
	time = now();
    }
    function pay(address token, uint256 tokenId, uint256 deposit) public {
	money.transferFrom(msg.sender, address(this), price[token][tokenId]);
	balance[token][tokenId] += deposit;
    }
    function expropriate(address token, uint256 tokenId, address to) public {
	uint256 tax = wmul(prices[token][tokenId], rate);
	money.transfer(lords[token][tokenId], min(tax, balance[token][tokenId]));
	if (tax > balance[token][tokenId]) {
	   token.transferFrom(address(this), to, tokenId);
	   wrappedTokens[token].burn(tokenId);
	}
    }
    function price(address token, uint256 tokenId, uint256 value) public {
	require(Harberged(wrappedTokens[token]).ownerOf(tokenId) == msg.sender);
	prices[token][tokenId] = price;
    }
}

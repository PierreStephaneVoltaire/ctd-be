--


--   Ad

CREATE TABLE if not exists Ad
(
    id             int        primary key   NOT NULL,
    isActive       boolean       NOT NULL,
    graphicUrl     varchar(100)  NOT NULL,
    destinationUrl varchar(1000) NULL,
    name           varchar(100)  NOT NULL,
    description    varchar(2000) NOT NULL,
    startDate      timestamp     NULL,
    endDate        timestamp     NULL,
    community      int           NULL DEFAULT 1,
    creationDate   timestamp     NOT NULL,
    type           text          NOT NULL
);


--   user

CREATE TABLE if not exists user
(
    username varchar(255) NOT NULL unique primary key
);

--   tags

CREATE TABLE if not exists tags
(
    id   int          NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,

    PRIMARY KEY (id)
);


--   themes

CREATE TABLE if not exists themes
(
    id   int  NOT NULL,
    name text NOT NULL,

    PRIMARY KEY (id)
);


--   profile

CREATE TABLE if not exists profile
(
    username    varchar(255) NOT NULL,
    bio         text         NULL,
    vanityTitle varchar(50)  NULL,
    avatar      text         NULL,
    job_title   text         NOT NULL,
    company     text         NOT NULL,
    tags        int          NULL,

    PRIMARY KEY (username),
    KEY fkIdx_159 (username),
    CONSTRAINT FK_158 FOREIGN KEY fkIdx_159 (username) REFERENCES user (username),
    KEY fkIdx_169 (tags),
    CONSTRAINT FK_168 FOREIGN KEY fkIdx_169 (tags) REFERENCES tags (id)
);


--   bannedUsers

CREATE TABLE if not exists bannedUsers
(
    id           int        primary key  NOT NULL,
    creationDate timestamp    NOT NULL,
    reason       varchar(500) NOT NULL,
    createdBy    varchar(255) NOT NULL,
    userName     varchar(255) NOT NULL,

    KEY fkIdx_207 (createdBy),
    CONSTRAINT FK_206 FOREIGN KEY fkIdx_207 (createdBy) REFERENCES user (username),
    KEY fkIdx_210 (userName),
    CONSTRAINT FK_209 FOREIGN KEY fkIdx_210 (userName) REFERENCES user (username)
);


--   blockedUsers

CREATE TABLE if not exists blockedUsers
(
    id           int    primary key   NOT NULL,
    CreationDate timestamp NOT NULL,
    username     varchar(255)      NOT NULL,
    blockedUser  varchar(255)      NOT NULL,

    KEY fkIdx_121 (username),
    CONSTRAINT FK_120 FOREIGN KEY fkIdx_121 (username) REFERENCES user (username),
    KEY fkIdx_124 (blockedUser),
    CONSTRAINT FK_123 FOREIGN KEY fkIdx_124 (blockedUser) REFERENCES user (username)
);

--   posts_type

CREATE TABLE if not exists posts_type
(
    id   int          NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL DEFAULT 'generic',

    PRIMARY KEY (id),
    UNIQUE KEY AK1_posts_type (name),
    UNIQUE KEY posts_type_index (id)
);


--   posts

CREATE TABLE if not exists posts
(
    id              int                        NOT NULL AUTO_INCREMENT,
    parent_id       int                        NULL,
    type            int                        ,
    score           int                        NOT NULL DEFAULT 0,
    community       int                        NULL     DEFAULT 1,
    title           varchar(255)               NOT NULL,
    subTitle        varchar(255)               NULL,
    thumbNailImage  varchar(255)               NULL,
    createdDate     timestamp                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updateDate      timestamp                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          enum ('published','draft') NOT NULL DEFAULT 'draft',
    summary         varchar(255)               NULL,
    author          varchar(255)                       NOT NULL,
    contentLocation varchar(255)               NOT NULL,

    PRIMARY KEY (id),
    KEY fkIdx_175 (author),
    CONSTRAINT FK_174 FOREIGN KEY fkIdx_175 (author) REFERENCES profile (username),
    KEY posts_parent_fk (parent_id),
    CONSTRAINT posts_parent_fk FOREIGN KEY posts_parent_fk (parent_id) REFERENCES posts (id) ON DELETE NO ACTION ON UPDATE CASCADE,
    KEY posts_type_fk (type),
    CONSTRAINT posts_type_fk FOREIGN KEY posts_type_fk (type) REFERENCES posts_type (id) ON DELETE SET NULL ON UPDATE CASCADE
);


--   comments

CREATE TABLE if not exists comments
(
    id               int       NOT NULL,
    content          longtext   NOT NULL,
    createdDate     timestamp                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updateDate      timestamp                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    isAnonymized     boolean    default false,
    isDistinguished  boolean   NOT NULL,
    FormattedContent longtext   ,
    parentId         int       NOT NULL,
    username         varchar(255)      NOT NULL,
    status           text      NOT NULL,
    post_fk          int       NOT NULL,

    PRIMARY KEY (id),
    KEY fkIdx_179 (parentId),
    CONSTRAINT FK_178 FOREIGN KEY fkIdx_179 (parentId) REFERENCES comments (id),
    KEY fkIdx_182 (username),
    CONSTRAINT FK_181 FOREIGN KEY fkIdx_182 (username) REFERENCES profile (username),
    KEY fkIdx_186 (post_fk),
    CONSTRAINT FK_185 FOREIGN KEY fkIdx_186 (post_fk) REFERENCES posts (id)
);


--   vote_types

CREATE TABLE if not exists vote_types
(
    id           int          NOT NULL AUTO_INCREMENT,
    name         varchar(100) NOT NULL DEFAULT 'upvote',
    last_updated timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY AK1_vote_types (name),
    UNIQUE KEY vote_type_index (id)
);


--   votes

CREATE TABLE if not exists votes
(
    id           int          NOT NULL AUTO_INCREMENT,
    status       varchar(100) NOT NULL DEFAULT 'show',
    last_updated timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    type         int          NULL,
    value        int          NOT NULL,
    post_id      int          NOT NULL,
    content      mediumtext      NULL,

    PRIMARY KEY (id),
    UNIQUE KEY votes_id_uindex (id),
    KEY fkIdx_58 (post_id),
    CONSTRAINT FK_57 FOREIGN KEY fkIdx_58 (post_id) REFERENCES posts (id),
    KEY votes_type_fk (type),
    CONSTRAINT votes_type_fk FOREIGN KEY votes_type_fk (type) REFERENCES vote_types (id) ON DELETE SET NULL ON UPDATE CASCADE
);


--   comment_votes

CREATE TABLE if not exists comment_votes
(
    id           int          NOT NULL AUTO_INCREMENT,
    status       varchar(100) NOT NULL DEFAULT 'show',
    last_updated timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    type         int          NULL,
    value        int          NOT NULL,
    comment_fk   int          NOT NULL,

    PRIMARY KEY (id),
    UNIQUE KEY votes_id_uindex_clone (id),
    KEY fkIdx_189 (comment_fk),
    CONSTRAINT FK_188 FOREIGN KEY fkIdx_189 (comment_fk) REFERENCES comments (id),
    KEY votes_type_fk_clone (type),
    CONSTRAINT votes_type_fk_clone FOREIGN KEY votes_type_fk_clone (type) REFERENCES vote_types (id) ON DELETE SET NULL ON UPDATE CASCADE
);


--   userPreferences

CREATE TABLE if not exists userPreferences
(
    username             varchar(255)                    NOT NULL,
    language             varchar(3)                      NOT NULL,
    openInNewWindow      boolean                         NOT NULL,
    displayAds           boolean                         NOT NULL,
    collapseCommentLimit int                             NULL,
    CommentSort          enum ('asc','desc')             NOT NULL,
    displayThumbnails    boolean                         NOT NULL,
    theme                int                             NOT NULL,
    blockAnonymized      enum ('collapse','hide','show') NOT NULL,

    PRIMARY KEY (username),
    KEY fkIdx_131 (theme),
    CONSTRAINT FK_130 FOREIGN KEY fkIdx_131 (theme) REFERENCES themes (id),
    KEY fkIdx_156 (username),
    CONSTRAINT FK_155 FOREIGN KEY fkIdx_156 (username) REFERENCES user (username)
);


 



































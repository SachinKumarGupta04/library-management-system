package com.library.util;

import org.apache.commons.dbcp2.BasicDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseUtil {
    private static BasicDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            InputStream inputStream = DatabaseUtil.class.getClassLoader()
                .getResourceAsStream("db.properties");
            
            if (inputStream != null) {
                props.load(inputStream);
                
                dataSource = new BasicDataSource();
                dataSource.setDriverClassName(props.getProperty("db.driver"));
                dataSource.setUrl(props.getProperty("db.url"));
                dataSource.setUsername(props.getProperty("db.username"));
                dataSource.setPassword(props.getProperty("db.password"));
                
                // Connection pool settings
                dataSource.setInitialSize(5);
                dataSource.setMaxTotal(20);
                dataSource.setMaxIdle(10);
                dataSource.setMinIdle(5);
                dataSource.setMaxWaitMillis(30000);
                
                inputStream.close();
            } else {
                throw new RuntimeException("Unable to find db.properties file");
            }
        } catch (IOException e) {
            throw new RuntimeException("Error loading database configuration", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource not initialized");
        }
        return dataSource.getConnection();
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static DataSource getDataSource() {
        return dataSource;
    }
}
